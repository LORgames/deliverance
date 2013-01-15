using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CityTools.Core;
using CityTools.Terrain;
using System.Drawing;
using System.IO;

namespace CityTools.Minimap {
    public class MinimapDrawer {

        public static void RedrawAllTerrain(LBuffer buffer, Rectangle minimapDrawArea) {
            if (File.Exists("minimap.jpg")) {
                buffer.gfx.DrawImage(Image.FromFile("minimap.jpg"), Point.Empty);
            } else {
                float scaleX = (float)minimapDrawArea.Width / (MapCache.TILE_SIZE_X * MapCache.TILE_TOTAL_X);
                float scaleY = (float)minimapDrawArea.Height / (MapCache.TILE_SIZE_Y * MapCache.TILE_TOTAL_Y);

                for (int i = 0; i < MapCache.TILE_TOTAL_X; i++) {
                    for (int j = 0; j < MapCache.TILE_TOTAL_Y; j++) {
                        RectangleF rf = new RectangleF(scaleX * i * MapCache.TILE_SIZE_X, scaleY * j * MapCache.TILE_SIZE_Y, scaleX * MapCache.TILE_SIZE_X, scaleY * MapCache.TILE_SIZE_Y);
                        byte tileID = MapCache.tiles[i, j];

                        buffer.gfx.DrawImage(ImageCache.RequestImage(MapCache.tileTable[tileID]), rf);
                    }
                }
            }
        }

        public static void UpdateTile(int i, int j) {
            float scaleX = (float)MainWindow.instance.minimap.DisplayRectangle.Width / (MapCache.TILE_SIZE_X * MapCache.TILE_TOTAL_X);
            float scaleY = (float)MainWindow.instance.minimap.DisplayRectangle.Height / (MapCache.TILE_SIZE_Y * MapCache.TILE_TOTAL_Y);

            RectangleF rf = new RectangleF(scaleX * i * MapCache.TILE_SIZE_X, scaleY * j * MapCache.TILE_SIZE_Y, scaleX * MapCache.TILE_SIZE_X, scaleY * MapCache.TILE_SIZE_Y);
            byte tileID = MapCache.tiles[i, j];

            MainWindow.instance.mapBuffer_ground.gfx.DrawImage(ImageCache.RequestImage(MapCache.tileTable[tileID]), rf);
            MainWindow.instance.minimap.Invalidate();
        }
    }
}
