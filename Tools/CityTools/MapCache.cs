using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using CityTools.components;
using ElephantNetworking;

namespace CityTools {
    public class MapCache {
        public static GenericClient client;

        public const string MAP_CACHE = ".\\mapcache\\";

        public const string MAP_BASE_PREFIX = "base_";
        public const string MAP_CEIL_PREFIX = "ceil_";
        public const string MAP_OBJECTS_PREFIX = "objects_";

        public const string MAP_SEPERATOR = "_";
        public const string MAP_FILETYPE = ".png";
        public const string MAP_EMPTY = ".\\blank.png";

        public static long[, ,] Filetimes;

        public static void VerifyCacheFiles() {
            client = new GenericClient("192.168.0.19", 12080);
            client.SendMessage(new NetworkMessage(NetworkMessageTypes.AssignmentGetLog));
            client.AddListener(new NetworkListener());

            Filetimes = new long[MainWindow.TILE_TX, MainWindow.TILE_TY, Enum.GetValues(typeof(PaintLayers)).Length];
            
            if (!Directory.Exists(MAP_CACHE)) Directory.CreateDirectory(MAP_CACHE);
            if (!Directory.Exists(ObjectCacheControl.OBJECT_CACHE_FOLDER)) Directory.CreateDirectory(ObjectCacheControl.OBJECT_CACHE_FOLDER);

            if (!File.Exists(MAP_EMPTY)) {
                MessageBox.Show("You need a 'blank' tile stored as " + MAP_EMPTY + "\n\n (such a baddie...)");
                MainWindow.instance.REQUIRES_CLOSE = true;
                return;
            }

            //Do a file check to make sure they all exist
            for (int i = 0; i < MainWindow.TILE_TX; i++) {
                for (int j = 0; j < MainWindow.TILE_TY; j++) {
                    foreach (var pl in Enum.GetValues(typeof(PaintLayers))) {
                        if (!File.Exists(GetTileFilename(i, j, (PaintLayers)pl))) {
                            File.Copy(MAP_EMPTY, GetTileFilename(i, j, (PaintLayers)pl));
                            File.SetLastWriteTimeUtc(GetTileFilename(i, j, (PaintLayers)pl), DateTime.MinValue);
                        }

                        Filetimes[i, j, (int)pl] = File.GetLastWriteTimeUtc(GetTileFilename(i, j, (PaintLayers)pl)).ToFileTime();
                    }
                }
            }

            return;
        }

        public static void FetchUpdate(int i, int j, PaintLayers l) {
            if (l == PaintLayers.Ground) {
                MainWindow.instance.base_images[i, j] = Image.FromFile(GetTileFilename(i, j, l));
            } else if (l == PaintLayers.Objects) {
                MainWindow.instance.object_images[i, j] = Image.FromFile(GetTileFilename(i, j, l));
            } else if (l == PaintLayers.Ceiling) {
                MainWindow.instance.top_images[i, j] = Image.FromFile(GetTileFilename(i, j, l));
            }
        }

        public static void Fetchmap(int mX, int mY, int wX, int wY, ref Rectangle cachedMapArea, int tries = 0) {
            if (cachedMapArea.Left <= mX && cachedMapArea.Right >= wX && cachedMapArea.Top <= mY && cachedMapArea.Bottom >= wY) {
                return;
            }

            int totalErrors = 0;

            for (int x = cachedMapArea.Left; x < cachedMapArea.Right; x++) {
                for (int y = cachedMapArea.Top; y < cachedMapArea.Bottom; y++) {
                    try {
                        if (MainWindow.instance.base_images[x, y] != null) {
                            MainWindow.instance.base_images[x, y].Dispose();
                        }
                    } catch {
                        totalErrors++;
                    }

                    try {
                        if (MainWindow.instance.top_images[x, y] != null) {
                            MainWindow.instance.top_images[x, y].Dispose();
                        }
                    } catch {
                        totalErrors++;
                    }

                    try {
                        if (MainWindow.instance.object_images[x, y] != null) {
                            MainWindow.instance.object_images[x, y].Dispose();
                        }
                    } catch {
                        totalErrors++;
                    }
                }
            }

            if (totalErrors > 0) MessageBox.Show("There are now locked tiles. \n" + totalErrors + " Errors occurred.");

            try {
                for (int i = mX; i <= wX; i++) {
                    for (int j = mY; j <= wY; j++) {
                        if (MainWindow.instance.layer_floor.Checked)
                            MainWindow.instance.base_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Ground));

                        if (MainWindow.instance.layer_ceiling.Checked)
                            MainWindow.instance.top_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Ceiling));

                        if (MainWindow.instance.layer_objects.Checked)
                            MainWindow.instance.object_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Objects));
                    }
                }
            } catch {
                if (tries == 0) {
                    GC.Collect();
                    Fetchmap(mX, mY, wX, wY, ref cachedMapArea, tries + 1);
                }
            }

            cachedMapArea = new Rectangle(mX, mY, wX - mX, wY - mY);
        }

        public static void outputCurrentCachedMapToFile(Rectangle cachedMapArea) {
            Bitmap bmp = new Bitmap(MainWindow.TILE_SX, MainWindow.TILE_SY);
            Graphics gfx = Graphics.FromImage(bmp);

            for (int i = cachedMapArea.Left; i <= cachedMapArea.Right; i++) {
                for (int j = cachedMapArea.Top; j <= cachedMapArea.Bottom; j++) {
                    if (!MainWindow.instance.needsToBeSaved[i, j]) continue;

                    gfx.Clear(Color.Transparent);

                    if (MainWindow.instance.activeLayer == PaintLayers.Ground) {
                        gfx.DrawImage(MainWindow.instance.base_images[i, j], Point.Empty);
                    } else if (MainWindow.instance.activeLayer == PaintLayers.Objects) {
                        gfx.DrawImage(MainWindow.instance.object_images[i, j], Point.Empty);
                    }

                    gfx.Flush();

                    MainWindow.instance.base_images[i, j].Dispose();
                    MainWindow.instance.object_images[i, j].Dispose();

                    int fails = 0;

                    while (true) {
                        try {
                            using (MemoryStream stream = new MemoryStream()) {
                                using (FileStream file = new FileStream(MapCache.GetTileFilename(i, j, MainWindow.instance.activeLayer), FileMode.Create, FileAccess.Write)) {
                                    bmp.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
                                    stream.WriteTo(file);
                                }
                            }
                            //bmp.Save(MapCache.GetTileFilename(i, j, MainWindow.instance.activeLayer));
                            break;
                        } catch (System.Runtime.InteropServices.ExternalException ex) {
                            //Lame
                            fails++;

                            if (fails == 1) {
                                //Maybe the gfx buffer is failing?
                                gfx.Dispose();
                                gfx = Graphics.FromImage(bmp);
                            } else if (fails == 2) {
                                //Try dispose again
                                MainWindow.instance.base_images[i, j].Dispose();
                                MainWindow.instance.object_images[i, j].Dispose();
                            } else if (fails == 3) {
                                //Maybe something is stuck in GC
                                GC.Collect();
                            } else if (fails > 3) {
                                MessageBox.Show("Unable to save chunk. \n\n" + ex.Message);
                                //Oh well, still no good, lets give up.
                                break;
                            }
                        } catch (Exception ex) {
                            MessageBox.Show("A programmer needs to be alerted (screenshot this message):\n\ncachesave 0x" + i + "x" + j + " failed with EX:\n\n" + ex.GetType().ToString() + "\n\n" + ex.Message);
                        }
                    }

                    MainWindow.instance.base_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Ground));
                    MainWindow.instance.object_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Objects));
                }
            }
        }

        public static string GetTileFilename(int i, int j, PaintLayers layer) {
            if (layer == PaintLayers.Ground)
                return MAP_CACHE + MAP_BASE_PREFIX + i + MAP_SEPERATOR + j + MAP_FILETYPE;
            
            if (layer == PaintLayers.Ceiling)
                return MAP_CACHE + MAP_CEIL_PREFIX + i + MAP_SEPERATOR + j + MAP_FILETYPE;
            
            if (layer == PaintLayers.Objects)
                return MAP_CACHE + MAP_OBJECTS_PREFIX + i + MAP_SEPERATOR + j + MAP_FILETYPE;
            
            return "";
        }
    }
}
