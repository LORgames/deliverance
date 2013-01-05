using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace CityToolsServer {
    public class Logger {
        private static Object semaphore = new object();
        private static Object semaphore_string = new object();

        private static Thread listenThread;

        private static string currentInput = "";
        private static bool running = true;

        private static NetworkLogHook networkhook;

        internal static void Initialize() {
            Console.TreatControlCAsInput = true;

            listenThread = new Thread(new ThreadStart(InputProcessor));
            listenThread.Start();

            networkhook = new NetworkLogHook();
            ElephantNetworking.Logger.AddHook(networkhook);
        }

        internal static void Shutdown() {
            Logger.Log("Shutting Down Logging...", "SERVER", ConsoleColor.Yellow, false);

            running = false;
            listenThread.Join();

            ElephantNetworking.Logger.RemoveHook(networkhook);

            Logger.Log("Done", "SERVER", ConsoleColor.Yellow, true, false);
        }

        internal static void Log(String msg, String component, ConsoleColor colour = ConsoleColor.White, bool UseWriteLine = true, bool WipeLine = true) {
            lock (semaphore) {
                Console.ForegroundColor = colour;

                if (UseWriteLine) {
                    Console.WriteLine((WipeLine ? "\r[" + component + "] " : "") + msg);
                } else {
                    Console.Write((WipeLine ? "\r[" + component + "] " : "") + msg);
                }
            }

            if(UseWriteLine) RedrawInput();
        }

        private static void RedrawInput() {
            lock (semaphore) {
                lock (semaphore_string) {
                    Console.ForegroundColor = ConsoleColor.White;
                    Console.Write("Command: " + currentInput);
                }
            }
        }

        private static void ClearLine() {
            lock (semaphore) {
                Console.Write("\r");
                for (int i = 0; i < Console.WindowWidth-6; i+=5) {
                    Console.Write("     ");
                }
                Console.Write("\r");
            }
        }

        private static void InputProcessor() {
            while (running) {
                while (Console.KeyAvailable) {
                    ConsoleKeyInfo nextChar = Console.ReadKey(true);

                    lock (semaphore_string) {
                        if (nextChar.Key == ConsoleKey.Backspace) {
                            if (currentInput.Length > 0) {
                                currentInput = currentInput.Remove(currentInput.Length - 1);
                                Console.Write("\b \b");
                            }
                        } else if (nextChar.Key == ConsoleKey.Enter) {
                            Console.Write("\n");
                            string command = currentInput;
                            currentInput = "";

                            Program.ProcessInput(command);
                        } else {
                            if (currentInput.Length < 30) {
                                currentInput += nextChar.KeyChar;
                                Console.Write(nextChar.KeyChar);
                            }
                        }
                    }
                }

                Thread.Sleep(100);
            }
        }
    }

    internal class NetworkLogHook : ElephantNetworking.ILogHook {
        public void  NetworkLog(string msg) {
     	    Logger.Log(msg, "NETWRK", ConsoleColor.Magenta);
        }
    }
}
