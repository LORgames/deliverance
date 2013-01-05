using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using CityTools.components;

namespace CityTools {
    public class MapCache {
        public const string MAP_CACHE = ".\\mapcache\\";

        public const string MAP_BASE_PREFIX = "base_";
        public const string MAP_CEIL_PREFIX = "ceil_";
        public const string MAP_OBJECTS_PREFIX = "objects_";

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
                    foreach (var pl in Enum.GetValues(typeof(PaintLayers))) {
                        if (!File.Exists(GetTileFilename(i, j, (PaintLayers)pl))) {
                            File.Copy(MAP_EMPTY, GetTileFilename(i, j, (PaintLayers)pl));
                        }
                    }
                }
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
