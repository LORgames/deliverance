using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace CityTools.Terrain {
    class TerrainDrawer {
        
        private static Point mousePos = Point.Empty;

        //return true if input layer needs a redraw :)
        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            mousePos = e.Location;

            Rectangle effectedArea = new Rectangle((int)(mousePos.X - MainWindow.instance.terrain_penSize.Value / 2), (int)(mousePos.Y - MainWindow.instance.terrain_penSize.Value / 2), (int)MainWindow.instance.terrain_penSize.Value, (int)MainWindow.instance.terrain_penSize.Value);

            inputBuffer.gfx.Clear(Color.Transparent);

            if (MainWindow.instance.paintShape == PaintShape.Square) {
                inputBuffer.gfx.FillRectangle(MainWindow.instance.terrainPaintBrush, effectedArea);
            } else if (MainWindow.instance.paintShape == PaintShape.Circle) {
                inputBuffer.gfx.FillEllipse(MainWindow.instance.terrainPaintBrush, effectedArea);
            }

            if (e.Button == System.Windows.Forms.MouseButtons.Left) {
                int oTileX, oTileY, wTileX, hTileY;

                float scaledTileSizeX = MainWindow.TILE_SX * MainWindow.instance.offsetZ;
                float scaledTileSizeY = MainWindow.TILE_SY * MainWindow.instance.offsetZ;

                oTileX = (int)Math.Floor((effectedArea.Left / scaledTileSizeX) + MainWindow.instance.offsetX);
                oTileY = (int)Math.Floor((effectedArea.Top / scaledTileSizeY) + MainWindow.instance.offsetY);
                wTileX = (int)Math.Floor((effectedArea.Right / scaledTileSizeX) + MainWindow.instance.offsetX);
                hTileY = (int)Math.Floor((effectedArea.Bottom / scaledTileSizeY) + MainWindow.instance.offsetY);

                if (oTileX < 0) oTileX = 0;
                if (oTileY < 0) oTileY = 0;
                if (wTileX >= MainWindow.TILE_TX) wTileX = MainWindow.TILE_TX - 1;
                if (hTileY >= MainWindow.TILE_TY) hTileY = MainWindow.TILE_TY - 1;

                for (int i = oTileX; i <= wTileX; i++) {
                    for (int j = oTileY; j <= hTileY; j++) {
                        MainWindow.instance.needsToBeSaved[i, j] = true;

                        float tX = ((effectedArea.Left / scaledTileSizeX) + MainWindow.instance.offsetX - i) * MainWindow.TILE_SX;
                        float tY = ((effectedArea.Top / scaledTileSizeY) + MainWindow.instance.offsetY - j) * MainWindow.TILE_SY;
                        float bX = ((effectedArea.Right / scaledTileSizeX) + MainWindow.instance.offsetX - i) * MainWindow.TILE_SX;
                        float bY = ((effectedArea.Bottom / scaledTileSizeY) + MainWindow.instance.offsetY - j) * MainWindow.TILE_SY;

                        Rectangle relativeRect = new Rectangle((int)tX, (int)tY, (int)(bX - tX), (int)(bY - tY));

                        try {
                            Graphics gfx = Graphics.FromImage(MainWindow.instance.terrain_images[i, j]);
                            gfx.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
                            gfx.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                            gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

                            if (MainWindow.instance.paintShape == PaintShape.Square) {
                                gfx.FillRectangle(MainWindow.instance.terrainPaintBrush, relativeRect);
                            } else if (MainWindow.instance.paintShape == PaintShape.Circle) {
                                gfx.FillEllipse(MainWindow.instance.terrainPaintBrush, relativeRect);
                            }

                            gfx.Dispose();
                        } catch {

                        }
                    }
                }
            }

            return true;
        }
    }
}
