using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Threading;
using System.Net;

namespace ElephantNetworking {
    public class GenericClient : INetworkInterface {
        const int SILENT_NETWORK_TICK_LENGTH_MS = 100; //100ms sleep for each client
        const int SILENT_NETWORK_TICKS_BEFORE_PING = 300; //30s
        const int SILENT_NETWORK_TICKS_EXPECTED_REPLY = 300; //30s

        private TcpClient tcpClient = null;
        private NetworkStream clientStream = null;

        private Thread listenThread = null;

        private NetworkListenerController listeners = new NetworkListenerController();

        private static bool SHUTDOWN_REQUIRED = false;

        private string stored_hostname = "";
        private int stored_postID = 0;

        private bool _isConnected = false;

        public bool IsConnected {
            get { return _isConnected; }
        }

        public GenericClient(string hostname, int portID, Boolean openNow = true) {
            stored_hostname = hostname;
            stored_postID = portID;

            if (openNow) Connect();
        }

        public bool Connect() {
            if (IsConnected) return false;

            SHUTDOWN_REQUIRED = false;

            try {
                if (tcpClient == null && clientStream == null && listenThread == null) {
                    tcpClient = new TcpClient(stored_hostname, stored_postID);
                    clientStream = tcpClient.GetStream();

                    listenThread = new Thread(new ThreadStart(HandleCommunications));
                    listenThread.Name = "GenericClient_ListenThread";
                    listenThread.Start();

                    _isConnected = true;
                } else {
                    return false;
                }

                return true;
            } catch (ArgumentNullException e) {
                Logger.Log(String.Format("ArgumentNullException: {0}", e));
            } catch (SocketException e) {
                Logger.Log(String.Format("SocketException: {0}", e));
            }

            return false;
        }

        public void AddListener(INetworkListen obj) {
            listeners.AddListener(obj);
        }

        public void RemoveListener(INetworkListen obj) {
            listeners.RemoveListener(obj);
        }

        public bool SendMessage(NetworkMessage message) {
            if (!IsConnected) {
                if (!Connect()) {
                    return false;
                }
            }

            try {
                byte[] outBytes;

                // Send the message to the connected TcpServer.
                int length;

                message.Encode(out outBytes, out length);

                lock (clientStream) {
                    if (clientStream.CanWrite) {
                        clientStream.Write(outBytes, 0, length);
                    }
                }

                Logger.Log(String.Format("Sent: {0}", message));

                message.Dispose();
                return true;
            } catch { }

            message.Dispose();
            return false;
        }

        public void Shutdown() {
            SendMessage(new NetworkMessage(NetworkMessageTypes.ProtocolClose));

            SHUTDOWN_REQUIRED = true;

            if (Thread.CurrentThread.Name != "GenericClient_ListenThread" && listenThread != null) {
                listenThread.Join();
            }
        }

        public void HandleCommunications() {
            byte[] messageHeaders = new byte[4];
            byte[] thisMessage = new byte[32];
            int bytesRead;

            int errors = 0;
            int timeout_ticks = 0;

            try {
                while (errors == 0) {
                    // Buffer to store the response bytes.
                    bytesRead = 0;

                    bool hasReading;

                    if (SHUTDOWN_REQUIRED) {
                        SendMessage(new NetworkMessage(NetworkMessageTypes.ProtocolClose));
                        break;
                    }

                    lock (clientStream) {
                        hasReading = clientStream.DataAvailable;
                    }

                    //Nothing to read, so just continue
                    if (!hasReading) {
                        timeout_ticks++;

                        if (!tcpClient.Connected) {
                            Logger.Log("A client has disconnected. Socket was closed.");
                            errors++;
                        } else if (timeout_ticks == SILENT_NETWORK_TICKS_BEFORE_PING) {
                            SendMessage(new NetworkMessage(NetworkMessageTypes.ProtocolPing));
                        } else if (timeout_ticks == SILENT_NETWORK_TICKS_BEFORE_PING + SILENT_NETWORK_TICKS_EXPECTED_REPLY) {
                            Logger.Log("A client has disconnected. Timeout has lapsed.");
                            errors++;
                        }

                        Thread.Sleep(100);
                        continue;
                    }

                    //Since there is data there, we can reset the timer. :)
                    timeout_ticks = 0;

                    lock (clientStream) {
                        while (clientStream.DataAvailable) {
                            try {
                                //blocks until a client sends a message
                                bytesRead = clientStream.Read(messageHeaders, 0, 4);
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

                            int length = IPAddress.NetworkToHostOrder(BitConverter.ToInt32(messageHeaders, 0));

                            if (thisMessage.Length < length) {
                                thisMessage = new byte[length];
                            }

                            bytesRead = 0;

                            try {
                                while (bytesRead < length) {
                                    bytesRead += clientStream.Read(thisMessage, bytesRead, length - bytesRead);
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
                            Logger.Log(String.Format("Recv: {0}", nm));

                            if (nm.Type == NetworkMessageTypes.ProtocolClose) {
                                nm.Dispose();
                                break;
                            } else if (nm.Type == NetworkMessageTypes.ProtocolPing) {
                                SendMessage(new NetworkMessage(NetworkMessageTypes.ProtocolPingReply));
                            } else if (nm.Type != NetworkMessageTypes.ProtocolPingReply) {
                                listeners.DeployMessage(nm);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                Logger.Log("ERROR: " + ex.Message);
                Logger.Log("STACK: " + ex.StackTrace);
            } finally {
                // Close everything.
                if (clientStream != null) {
                    clientStream.Close();
                    clientStream = null;
                }

                if (tcpClient != null) {
                    tcpClient.Close();
                    tcpClient = null;
                }

                _isConnected = false;
                listenThread = null;

                Logger.Log("Client thread closed...");
            }
        }
    }
}
