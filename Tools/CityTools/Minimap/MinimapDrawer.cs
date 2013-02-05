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
            if (File.Exists("minimap_new.jpg")) {
                File.Delete("minimap.jpg");
                File.Move("minimap_new.jpg", "minimap.jpg");
            }

            if (File.Exists("minimap.jpg")) {
                buffer.gfx.DrawImage(Image.FromFile("minimap.jpg"), Point.Empty);
            } else {
                float scaleX = (float)minimapDrawArea.Width / (MapCache.TILE_SIZE_X * MapCache.TILE_TOTAL_X);
                float scaleY = (float)minimapDrawArea.Height / (MapCache.TILE_SIZE_Y * MapCache.TILE_TOTAL_Y);

                for (int i = 0; i < MapCache.TILE_TOTAL_X; i++) {
                    for (int j = 0; j < MapCache.TILE_TOTAL_Y; j++) {
                        Rectangle rf = new Rectangle((int)Math.Round(scaleX * i * MapCache.TILE_SIZE_X), (int)Math.Round(scaleY * j * MapCache.TILE_SIZE_Y), (int)Math.Round(scaleX * MapCache.TILE_SIZE_X), (int)Math.Round(scaleY * MapCache.TILE_SIZE_Y));
                        byte tileID = MapCache.tiles[i, j];

                        buffer.gfx.DrawImage(ImageCache.RequestImage(MapCache.tileTable[tileID]), rf);
                    }
                }
            }
        }

        public static void UpdateTile(int i, int j) {
            float scaleX = (float)MainWindow.instance.minimap.DisplayRectangle.Width / (MapCache.TILE_SIZE_X * MapCache.TILE_TOTAL_X);
            float scaleY = (float)MainWindow.instance.minimap.DisplayRectangle.Height / (MapCache.TILE_SIZE_Y * MapCache.TILE_TOTAL_Y);

            Rectangle rf = new Rectangle((int)Math.Round(scaleX * i * MapCache.TILE_SIZE_X), (int)Math.Round(scaleY * j * MapCache.TILE_SIZE_Y), (int)Math.Round(scaleX * MapCache.TILE_SIZE_X), (int)Math.Round(scaleY * MapCache.TILE_SIZE_Y));
            byte tileID = MapCache.tiles[i, j];

            MainWindow.instance.minimapBuffer.gfx.DrawImage(ImageCache.RequestImage(MapCache.tileTable[tileID]), rf);
            MainWindow.instance.minimap.Invalidate();
        }
    }
}
