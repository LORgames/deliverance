using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CityToolsServer {
    class Program {
        private static MultiuserConnectionServer mcs;

        static void Main(string[] args) {
            Logger.Initialize();
            MapCache.VerifyCacheFiles();

            mcs = new MultiuserConnectionServer();
        }
    }
}
