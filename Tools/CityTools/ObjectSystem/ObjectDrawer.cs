using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace CityTools.ObjectSystem {
    class ObjectDrawer {
        private static Point mousePos = Point.Empty;

        public static string image_name = "";

        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            mousePos = e.Location;

            RectangleF effectedArea = new RectangleF(mousePos.X - (MainWindow.instance.obj_paint_image.Width * MainWindow.instance.offsetZ / 2), mousePos.Y - (MainWindow.instance.obj_paint_image.Height * MainWindow.instance.offsetZ / 2), MainWindow.instance.obj_paint_image.Width * MainWindow.instance.offsetZ, MainWindow.instance.obj_paint_image.Height * MainWindow.instance.offsetZ);

            Rectangle eD = new Rectangle((int)effectedArea.Left, (int)effectedArea.Top, (int)Math.Round(effectedArea.Width), (int)Math.Round(effectedArea.Height));

            inputBuffer.gfx.Clear(Color.Transparent);
            inputBuffer.gfx.DrawImage(MainWindow.instance.obj_paint_image, eD);

            if (e.Button == System.Windows.Forms.MouseButtons.Left && !MainWindow.instance.was_mouse_down) {
                MainWindow.instance.was_mouse_down = true;

                RectangleF eA = new RectangleF(effectedArea.Left + MainWindow.instance.offsetX * MainWindow.TILE_SX, effectedArea.Top + MainWindow.instance.offsetY * MainWindow.TILE_SY, effectedArea.Width, effectedArea.Height);

                ObjectCache.AddShape(new ScenicObject(image_name, new PointF(eA.Left, eA.Top), (float)MainWindow.instance.obj_rot.Value));

                return true;
            }

            return false;
        }
    }
}
