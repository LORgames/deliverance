using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.IO;

namespace ElephantNetworking {
    public class Logger {
        private static Object semaphore = new object();
        private const string LOG_NAME = "C:\\Logs\\Elephant_Networking.log";

        private static Object semaphore_hook = new object();
        private static List<ILogHook> hooks = new List<ILogHook>(1);

        internal static void Log(String msg) {
            lock (semaphore) {
                //StreamWriter fs = File.AppendText(LOG_NAME);
                //fs.Write(DateTime.Now.ToString() + "\t" + msg + "\r\n");
                //fs.Close();
            }

            lock (semaphore_hook) {
                foreach (ILogHook hook in hooks) {
                    hook.NetworkLog(msg);
                }
            }
        }

        public static void AddHook(ILogHook hook) {
            lock(semaphore_hook) {
                hooks.Add(hook);
            }
        }

        public static void RemoveHook(ILogHook hook) {
            lock (semaphore_hook) {
                hooks.Remove(hook);
            }
        }
    }

    public interface ILogHook {
        void NetworkLog(string msg);
    }
}
