using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using CityTools.Components;
using CityTools.Core;

namespace CityTools.Terrain {
    public class MapCache {
        public const string MAP_FILENAME = Program.CACHE + "map.db";
        public const string TILE_DIRECTORY = ".\\Tiles\\";

        public const int TILE_SIZE_X = 146; //The width of a single image block
        public const int TILE_SIZE_Y = 146; //The height of a single image block

        public const int TILE_TOTAL_X = 128; //How many image blocks across
        public const int TILE_TOTAL_Y = 128; //How many image blocks down

        public static Dictionary<byte, string> tileTable = new Dictionary<byte, string>();

        public static byte[,] tiles;

        public static void VerifyCacheFiles() {
            // Create the map thing
            tiles = new byte[TILE_TOTAL_X, TILE_TOTAL_Y];

            for (int i = 0; i < TILE_TOTAL_X; i++) {
                for (int j = 0; j < TILE_TOTAL_Y; j++) {
                    tiles[i, j] = 1;
                }
            }

            foreach (string file in Directory.GetFiles(TILE_DIRECTORY, "*.png", SearchOption.AllDirectories)) {
                byte tileIndex = TerrainHelper.StripTileIDFromPath(file);

                if (tileTable.ContainsKey(tileIndex)) {
                    MessageBox.Show("Both " + tileTable[tileIndex] + " and " + file + " are tile #" + tileIndex + "\n\nIgnoring: " + file);
                } else {
                    tileTable.Add(tileIndex, file);
                }
            }

            // Load the map from database
            if (File.Exists(MAP_FILENAME)) {
                LoadMapFromFile();
            }

            return;
        }

        private static void LoadMapFromFile() {
            BinaryIO mapFile = new BinaryIO(File.ReadAllBytes(MAP_FILENAME));

            int lmSizeX = mapFile.GetInt(TILE_TOTAL_X);
            int lmSizeY = mapFile.GetInt(TILE_TOTAL_Y);

            for (int i = 0; i < Math.Min(TILE_TOTAL_X, lmSizeX); i++) {
                for (int j = 0; j < Math.Min(TILE_TOTAL_Y, lmSizeY); j++) {
                    tiles[i, j] = mapFile.GetByte();
                }
            }

            mapFile.Dispose();
        }

        public static void SaveMap() {
            BinaryIO mapFile = new BinaryIO();

            mapFile.AddInt(TILE_TOTAL_X);
            mapFile.AddInt(TILE_TOTAL_Y);

            for (int i = 0; i < TILE_TOTAL_X; i++) {
                for (int j = 0; j < TILE_TOTAL_Y; j++) {
                    mapFile.AddByte(tiles[i, j]);
                }
            }

            mapFile.Encode(MAP_FILENAME);
        }
    }
}
