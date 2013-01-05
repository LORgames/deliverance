using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ElephantNetworking;
using System.Windows.Forms;
using System.IO;
using System.Drawing;

namespace CityTools {
    class NetworkListener : INetworkListen {

        private List<Rectangle> neededFiles = new List<Rectangle>();
        private bool isAwaitingFile = false;

        public NetworkListener() {
            //Not sure it needs to do anything?
        }

        bool INetworkListen.OnData(NetworkMessage data) {
            if (data.Type == NetworkMessageTypes.AssignmentUpload) {
                int i = data.GetInt();
                int j = data.GetInt();
                int layer = data.GetInt();

                DateTime time = DateTime.FromFileTimeUtc(data.GetLong());

                string fname = MapCache.GetTileFilename(i, j, (PaintLayers)layer);
                data.DecodeFile(fname);

                File.SetLastWriteTimeUtc(fname, time);
                MapCache.FetchUpdate(i, j, (PaintLayers)layer);

                isAwaitingFile = false;
                RequestNext();
            } else if(data.Type == NetworkMessageTypes.AssignmentGetLog) {
                int serv_TX = data.GetInt(); //X stuff
                int serv_TY = data.GetInt(); //Y stuff
                int serv_TZ = data.GetInt(); //Layers
                
                if(serv_TX != MainWindow.TILE_TX || serv_TY != MainWindow.TILE_TY || serv_TZ != Enum.GetValues(typeof(PaintLayers)).Length) {
                    MessageBox.Show("Server is running a different map format.");
                    throw new IndexOutOfRangeException("Such a baddie.");
                }

                long[, ,] filetimes = new long[serv_TX, serv_TY, serv_TZ];

                for (int i = 0; i < serv_TX; i++) {
                    for (int j = 0; j < serv_TY; j++) {
                        for (int l = 0; l < serv_TZ; l++) {
                            filetimes[i, j, l] = data.GetLong();

                            if (filetimes[i, j, l] > MapCache.Filetimes[i, j, l]) {
                                neededFiles.Add(new Rectangle(i, j, l, 0));
                            }
                        }
                    }
                }

                RequestNext();
            }

            return true;
        }

        private void RequestNext() {
            if (!isAwaitingFile && neededFiles.Count > 0) {
                isAwaitingFile = true;

                int i = neededFiles[0].Left;
                int j = neededFiles[0].Right;
                int l = neededFiles[0].Width;
                neededFiles.RemoveAt(0);

                NetworkMessage nm7 = new NetworkMessage(NetworkMessageTypes.AssignmentCopyAddress);
                nm7.AddInt(i);
                nm7.AddInt(j);
                nm7.AddInt(l);
                MapCache.client.SendMessage(nm7);
            }
        }
    }
}
