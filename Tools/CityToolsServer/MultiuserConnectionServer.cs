using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ElephantNetworking;
using System.IO;

namespace CityToolsServer {
    public class MultiuserConnectionServer : INetworkListen {
        GenericServer server;

        public MultiuserConnectionServer() {
            server = new GenericServer(12080);
            server.AddListener(this);
        }

        public bool OnData(NetworkMessage data) {
            if (data.Type == NetworkMessageTypes.AssignmentGetLog) {
                NetworkMessage nm = new NetworkMessage(NetworkMessageTypes.AssignmentGetLog);
                nm.AddInt(MapCache.TILE_TX); //X stuff
                nm.AddInt(MapCache.TILE_TY); //Y stuff
                nm.AddInt(MapCache.TILE_TZ); //Layers

                for (int i = 0; i < MapCache.TILE_TX; i++) {
                    for (int j = 0; j < MapCache.TILE_TY; j++) {
                        for (int l = 0; l < MapCache.TILE_TZ; l++) {
                            nm.AddLong(MapCache.filetimes[i, j, l]);
                        }
                    }
                }

                server.SendMessageTo(data.sockPTR, nm);
            } else if (data.Type == NetworkMessageTypes.AssignmentUpload) {
                int i = data.GetInt();
                int j = data.GetInt();
                int layer = data.GetInt();

                string fname = MapCache.GetTileFilename(i, j, layer);
                data.DecodeFile(fname);

                NetworkMessage nm = new NetworkMessage(NetworkMessageTypes.AssignmentUpload);
                nm.AddInt(i);
                nm.AddInt(j);
                nm.AddInt(layer);
                nm.AddLong(File.GetLastWriteTime(MapCache.GetTileFilename(i, j, layer)).ToFileTimeUtc());
                nm.EncodeFile(fname);

                server.SendMessageTo(data.sockPTR, nm);
            } else if (data.Type == NetworkMessageTypes.AssignmentCopyAddress) {
                int i = data.GetInt();
                int j = data.GetInt();
                int layer = data.GetInt();

                NetworkMessage nm = new NetworkMessage(NetworkMessageTypes.AssignmentUpload);
                nm.AddInt(i);
                nm.AddInt(j);
                nm.AddInt(layer);
                nm.AddLong(File.GetLastWriteTime(MapCache.GetTileFilename(i, j, layer)).ToFileTimeUtc());
                nm.EncodeFile(MapCache.GetTileFilename(i, j, layer));

                server.SendMessageTo(data.sockPTR, nm);
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
