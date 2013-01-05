using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace CityToolsServer {
    public class MapCache {
        public const string MAP_CACHE = ".\\mapcache\\";

        public const string MAP_BASE_PREFIX = "base_";
        public const string MAP_CEIL_PREFIX = "ceil_";
        public const string MAP_OBJECTS_PREFIX = "objects_";

        public const string MAP_SEPERATOR = "_";
        public const string MAP_FILETYPE = ".png";
        public const string MAP_EMPTY = ".\\blank.png";

        public const int TILE_SX = 1024; //The width of a single image block
        public const int TILE_SY = 1024; //The height of a single image block

        public const int TILE_TX = 16; //How many image blocks across
        public const int TILE_TY = 16; //How many image blocks down

        public static void VerifyCacheFiles() {
            if (!Directory.Exists(MAP_CACHE)) Directory.CreateDirectory(MAP_CACHE);

            //Do a file check to make sure they all exist
            for (int i = 0; i < TILE_TX; i++) {
                for (int j = 0; j < TILE_TY; j++) {
                    for (int l = 0; l < 3; l++) {
                        if (!File.Exists(GetTileFilename(i, j, l))) {
                            File.Copy(MAP_EMPTY, GetTileFilename(i, j, l));
                        }
                    }
                }
            }
        }

        public static string GetTileFilename(int i, int j, int layer) {
            if (layer == 0) //PaintLayers.Ground
                return MAP_CACHE + MAP_BASE_PREFIX + i + MAP_SEPERATOR + j + MAP_FILETYPE;
            
            if (layer == 1) //PaintLayers.Ceiling
                return MAP_CACHE + MAP_CEIL_PREFIX + i + MAP_SEPERATOR + j + MAP_FILETYPE;
            
            if (layer == 2) //PaintLayers.Objects
                return MAP_CACHE + MAP_OBJECTS_PREFIX + i + MAP_SEPERATOR + j + MAP_FILETYPE;
            
            return "";
        }

    }
}
