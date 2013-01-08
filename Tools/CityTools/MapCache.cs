using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using CityTools.Components;

namespace CityTools {
    public class MapCache {
        public const string MAP_CACHE = ".\\terrain\\";

        public const string MAP_SEPERATOR = "_";
        public const string MAP_FILETYPE = ".png";
        public const string MAP_EMPTY = ".\\blank.png";

        public static void VerifyCacheFiles() {
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
                    if (!File.Exists(GetTileFilename(i, j))) {
                        File.Copy(MAP_EMPTY, GetTileFilename(i, j));
                    }
                }
            }

            return;
        }

        public static void FetchUpdate(int i, int j) {
            MainWindow.instance.terrain_images[i, j] = Image.FromFile(GetTileFilename(i, j));
        }

        public static void Fetchmap(int mX, int mY, int wX, int wY, ref Rectangle cachedMapArea, int tries = 0) {
            if (cachedMapArea.Left <= mX && cachedMapArea.Right >= wX && cachedMapArea.Top <= mY && cachedMapArea.Bottom >= wY) {
                return;
            }

            int totalErrors = 0;

            for (int x = cachedMapArea.Left; x < cachedMapArea.Right; x++) {
                for (int y = cachedMapArea.Top; y < cachedMapArea.Bottom; y++) {
                    try {
                        if (MainWindow.instance.terrain_images[x, y] != null) {
                            MainWindow.instance.terrain_images[x, y].Dispose();
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
                            MainWindow.instance.terrain_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j));
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
                    gfx.DrawImage(MainWindow.instance.terrain_images[i, j], Point.Empty);
                    gfx.Flush();

                    if(MainWindow.instance.terrain_images[i,j] != null)
                        MainWindow.instance.terrain_images[i, j].Dispose();

                    int fails = 0;

                    while (true) {
                        try {
                            bmp.Save(MapCache.GetTileFilename(i, j));
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
                                MainWindow.instance.terrain_images[i, j].Dispose();
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

                    MainWindow.instance.terrain_images[i, j] = Image.FromFile(MapCache.GetTileFilename(i, j));
                }
            }
        }

        public static string GetTileFilename(int i, int j) {
            return MAP_CACHE + i + MAP_SEPERATOR + j + MAP_FILETYPE;
        }
    }
}
