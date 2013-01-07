using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace CityTools.Object {
    class ObjectDrawer {

        private static Point mousePos = Point.Empty;

        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            mousePos = e.Location;

            RectangleF effectedArea = new RectangleF(mousePos.X - (MainWindow.instance.obj_paint_image.Width * MainWindow.instance.offsetZ / 2), mousePos.Y - (MainWindow.instance.obj_paint_image.Height * MainWindow.instance.offsetZ / 2), MainWindow.instance.obj_paint_image.Width * MainWindow.instance.offsetZ, MainWindow.instance.obj_paint_image.Height * MainWindow.instance.offsetZ);

            Rectangle eD = new Rectangle((int)effectedArea.Left, (int)effectedArea.Top, (int)Math.Round(effectedArea.Width), (int)Math.Round(effectedArea.Height));

            inputBuffer.gfx.Clear(Color.Transparent);
            inputBuffer.gfx.DrawImage(MainWindow.instance.obj_paint_image, eD);

            if (e.Button == System.Windows.Forms.MouseButtons.Left && !MainWindow.instance.was_mouse_down) {
                MainWindow.instance.was_mouse_down = true;

                int oTileX, oTileY, wTileX, hTileY;

                RectangleF effectedCells = new RectangleF(effectedArea.Left / MainWindow.TILE_SX, effectedArea.Top / MainWindow.TILE_SY, 1 + effectedArea.Width / MainWindow.TILE_SX, 1 + effectedArea.Height / MainWindow.TILE_SY);

                effectedCells.Offset(MainWindow.instance.offsetX, MainWindow.instance.offsetY);

                oTileX = (int)effectedCells.Left;
                oTileY = (int)effectedCells.Top;
                wTileX = (int)Math.Ceiling(effectedCells.Right);
                hTileY = (int)Math.Ceiling(effectedCells.Bottom);

                if (oTileX < 0) oTileX = 0;
                if (oTileY < 0) oTileY = 0;
                if (wTileX > MainWindow.TILE_TX) wTileX = MainWindow.TILE_TX;
                if (hTileY > MainWindow.TILE_TY) hTileY = MainWindow.TILE_TY;

                for (int i = oTileX; i <= wTileX; i++) {
                    for (int j = oTileY; j <= hTileY; j++) {
                        MainWindow.instance.needsToBeSaved[i, j] = true;

                        float tX = effectedArea.Left + MainWindow.TILE_SX * (MainWindow.instance.offsetX - i);
                        float tY = effectedArea.Top + MainWindow.TILE_SY * (MainWindow.instance.offsetY - j);
                        float bX = effectedArea.Right + MainWindow.TILE_SX * (MainWindow.instance.offsetX - i);
                        float bY = effectedArea.Bottom + MainWindow.TILE_SY * (MainWindow.instance.offsetY - j);

                        Rectangle relativeRect = new Rectangle((int)Math.Round(tX), (int)Math.Round(tY), MainWindow.instance.obj_paint_image.Width, MainWindow.instance.obj_paint_image.Height);

                        try {
                            Graphics gfx = Graphics.FromImage(MainWindow.instance.object_images[i, j]);
                            gfx.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
                            gfx.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                            gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

                            gfx.DrawImage(MainWindow.instance.obj_paint_image, relativeRect);

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
