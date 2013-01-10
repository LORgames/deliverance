using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CityTools.Core;
using System.Drawing;
using System.IO;
using CityTools.Components;

namespace CityTools.Terrain {
    public class TerrainHelper {

        private static byte currentTile = 0;
        private static Image currentTileIm = null;

        public static void InitializeTerrainSystem(ComboBox cb, Panel objPanel) {
            List<String> dark = new List<string>();
            dark.InsertRange(0, Directory.GetDirectories(MapCache.TILE_DIRECTORY));

            if (dark.Count > 0) {
                objPanel.Controls.Add(new ObjectCacheControl(dark[0], false));
            }

            cb.DataSource = dark;
        }

        public static void MouseMoveOrDown(MouseEventArgs e, LBuffer input_buffer) {
            input_buffer.gfx.Clear(Color.Transparent);

            Point m = e.Location;

            Point tilePos = Point.Empty;
            tilePos.X = (int)((Camera.Offset.X + m.X / Camera.ZoomLevel) / MapCache.TILE_SIZE_X);
            tilePos.Y = (int)((Camera.Offset.Y + m.Y / Camera.ZoomLevel) / MapCache.TILE_SIZE_Y);

            input_buffer.gfx.DrawImage(currentTileIm, new RectangleF(tilePos.X * MapCache.TILE_SIZE_X * Camera.ZoomLevel - Camera.Offset.X, tilePos.Y * MapCache.TILE_SIZE_Y * Camera.ZoomLevel - Camera.Offset.Y, MapCache.TILE_SIZE_X * Camera.ZoomLevel, MapCache.TILE_SIZE_Y * Camera.ZoomLevel));

            if (e.Button == MouseButtons.Left) {
                MapCache.tiles[tilePos.X, tilePos.Y] = currentTile;
            }
        }

        public static void DrawTerrain() {

        }

        public static void SetCurrentTile(byte newTile) {
            currentTile = newTile;
            currentTileIm = ImageCache.RequestImage(MapCache.tileTable[newTile]);
        }


        internal static byte StripTileIDFromPath(string pathName) {
            int i1 = pathName.LastIndexOf('\\');
            int i2 = pathName.LastIndexOf('.');

            string ttt = pathName.Substring(i1 + 1, i2 - i1 - 1);
            return byte.Parse(ttt);
        }
    }
}
