using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ElephantNetworking;

namespace CityToolsServer {
    public class MultiuserConnectionServer : INetworkListen {
        GenericServer server;

        public MultiuserConnectionServer() {
            server = new GenericServer(12080);
            server.AddListener(this);
        }

        public bool OnData(NetworkMessage data) {
            if (data.Type == NetworkMessageTypes.AssignmentGetLog) {

            }

            return true;
        }
    }
}
