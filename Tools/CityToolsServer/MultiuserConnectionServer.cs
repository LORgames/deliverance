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

            } else if (data.Type == NetworkMessageTypes.AssignmentUpload) {
                int i = data.GetInt();
                int j = data.GetInt();
                int layer = data.GetInt();

                string fname = MapCache.GetTileFilename(i, j, layer);
                data.DecodeFile(fname);
            }

            return true;
        }

        private void UpdateToTileAlert(int i, int j, int layer) {
            NetworkMessage nm = new NetworkMessage(NetworkMessageTypes.AssignmentUpload);
            nm.AddInt(i);
            nm.AddInt(j);
            nm.AddInt(layer);

            string fname = MapCache.GetTileFilename(i, j, layer);

            nm.EncodeFile(fname);

            server.SendMessage(nm);
        }
    }
}
