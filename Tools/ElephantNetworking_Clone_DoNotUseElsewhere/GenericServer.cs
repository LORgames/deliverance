using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.Threading;

namespace ElephantNetworking {
    public class GenericServer : INetworkInterface {
        const int SILENT_NETWORK_TICK_LENGTH_MS = 100; //100ms sleep for each client
        const int SILENT_NETWORK_TICKS_BEFORE_PING = 300; //30s
        const int SILENT_NETWORK_TICKS_EXPECTED_REPLY = 300; //30s

        private TcpListener tcpListener;

        private Object semaphore = new object();
        private Object semaphore_client = new object();
        private Object semaphore_counter = new object();

        private Thread listenThread;
        public int threadCounter;

        private static bool SHUTDOWN_REQUIRED = false;

        private List<NetworkStream> clients = new List<NetworkStream>();
        private NetworkListenerController listeners = new NetworkListenerController();

        public GenericServer(int portNumber) {
            this.tcpListener = new TcpListener(IPAddress.Any, portNumber);

            if (tcpListener == null) {
                throw new Exception("BAD TCP Listener");
            }

            this.listenThread = new Thread(new ThreadStart(ListenForClients));
            this.listenThread.Name = "GenericServer_ListenThread";
            this.listenThread.Start();
        }

        public void AddListener(INetworkListen obj) {
            listeners.AddListener(obj);
        }

        public void RemoveListener(INetworkListen obj) {
            listeners.RemoveListener(obj);
        }

        public void SendMessageTo(NetworkStream clientStream, NetworkMessage message) {
            try {
                lock (clientStream) {
                    if (clientStream.CanWrite) {
                        byte[] outBytes;
                        int length;
                        message.Encode(out outBytes, out length);

                        clientStream.Write(outBytes, 0, length);
                    }
                }
            } catch {

            } finally {
                message.Dispose();
            }
        }

        public bool SendMessage(NetworkMessage message) {
            message.Dispose();
            throw new NotImplementedException("This method is not used in elephant. Please stop calling it.");
        }

        public void Shutdown() {
            lock (semaphore) {
                if (tcpListener != null) {
                    tcpListener.Stop();
                    tcpListener = null;
                }
            }

            SHUTDOWN_REQUIRED = true;

            while (true) {
                lock (semaphore_counter) {
                    if (threadCounter == 0)
                        break;

                    Thread.Sleep(SILENT_NETWORK_TICK_LENGTH_MS);
                }
            }

            listenThread.Join();
        }

        private void ListenForClients() {
            this.tcpListener.Start(50);

            while (this.tcpListener != null) {
                lock (semaphore) {
                    if (tcpListener != null && tcpListener.Pending()) {
                        //blocks until a client has connected to the server
                        TcpClient client = this.tcpListener.AcceptTcpClient();

                        //TODO: single thread that checks all the clients rather than 1 client per thread
                        //create a thread to handle communication with connected client
                        Thread clientThread = new Thread(new ParameterizedThreadStart(HandleClientComm));
                        clientThread.Name = "GenericServer_ClientThread";
                        clientThread.Start(client);

                        lock (semaphore_counter) {
                            threadCounter++;
                        }
                    }
                }

                Thread.Sleep(SILENT_NETWORK_TICK_LENGTH_MS);
            }
        }

        private void HandleClientComm(object client) {
            TcpClient tcpClient = (TcpClient)client;
            NetworkStream clientStream = tcpClient.GetStream();
            byte[] messageSize = new byte[4];

            lock (semaphore_client) {
                clients.Add(clientStream);
            }

            int bytesRead;

            int errors = 0;
            int timeout_ticks = 0;

            while (errors == 0) {
                if (SHUTDOWN_REQUIRED) {
                    break;
                }

                bytesRead = 0;

                bool hasReading;

                lock (clientStream) {
                    hasReading = clientStream.DataAvailable;
                }

                //Nothing to read, so just continue
                if (!hasReading) {
                    timeout_ticks++;

                    if (!tcpClient.Connected) {
                        Logger.Log("A client has disconnected. Socket was closed unexpectedly.");
                        errors++;
                    } else if (timeout_ticks == SILENT_NETWORK_TICKS_BEFORE_PING) {
                        SendMessageTo(clientStream, new NetworkMessage(NetworkMessageTypes.ProtocolPing));
                    } else if (timeout_ticks == SILENT_NETWORK_TICKS_BEFORE_PING + SILENT_NETWORK_TICKS_EXPECTED_REPLY) {
                        Logger.Log("A client has disconnected. Timeout has lapsed.");
                        errors++;
                    }

                    Thread.Sleep(SILENT_NETWORK_TICK_LENGTH_MS);
                    continue;
                }

                //Since there is data there, we can reset the timer. :)
                timeout_ticks = 0;

                lock (clientStream) {
                    while (clientStream.DataAvailable) {
                        try {
                            //blocks until a client sends a message
                            bytesRead = clientStream.Read(messageSize, 0, 4);
                        } catch {
                            //a socket error has occured
                            errors++;
                            break;
                        }

                        if (bytesRead == 0) {
                            //the client has disconnected from the server
                            errors++;
                            break;
                        }

                        int length = IPAddress.NetworkToHostOrder(BitConverter.ToInt32(messageSize, 0));
                        byte[] thisMessage = new byte[length];

                        bytesRead = 0;

                        try {
                            while (bytesRead < length) {
                                bytesRead += clientStream.Read(thisMessage, bytesRead, length-bytesRead);
                            }
                        } catch {
                            //a socket error has occured
                            errors++;
                            break;
                        }

                        if (bytesRead == 0) {
                            errors++;
                            break;
                        }

                        NetworkMessage nm = new NetworkMessage(thisMessage);
                        nm.sockPTR = clientStream;

                        if (nm.Type == NetworkMessageTypes.ProtocolClose) {
                            nm.Dispose();
                            Logger.Log("A client has disconnected. Socket was closed via protocol.");
                            break;
                        } else if (nm.Type == NetworkMessageTypes.ProtocolPing) {
                            SendMessageTo(clientStream, new NetworkMessage(NetworkMessageTypes.ProtocolPingReply));
                            nm.Dispose();
                        } else if (nm.Type != NetworkMessageTypes.ProtocolPingReply) {
                            listeners.DeployMessage(nm);
                        }
                    }
                }
            }

            //Logger.Log("Shutting down client...");

            clientStream.Close();
            tcpClient.Close();

            //Logger.Log("\tClosed sockets");

            lock (semaphore_client) {
                clients.Remove(clientStream);
            }

            //Logger.Log("\tRemoved From Queue");

            lock (semaphore_counter) {
                threadCounter--;
            }

            //Logger.Log("\tExited cleanly.");
        }
    }
}
