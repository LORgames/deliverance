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

            return false;
        }

        internal static bool MouseDown(MouseEventArgs e, LBuffer input_buffer) {
            mousePos = e.Location;

            PointF p0 = new PointF(mousePos.X / MainWindow.instance.offsetZ + MainWindow.instance.viewArea.Left, mousePos.Y / MainWindow.instance.offsetZ + MainWindow.instance.viewArea.Top);

            PointF p1 = PointF.Empty;
            p1.X = MainWindow.instance.obj_paint_image.Width * MainWindow.instance.offsetZ;
            p1.Y = MainWindow.instance.obj_paint_image.Height * MainWindow.instance.offsetZ;

            RectangleF eA = new RectangleF(p0.X, p0.Y, p1.X, p1.Y);
            ObjectCache.AddShape(new ScenicObject(image_name, new PointF(eA.Left, eA.Top), (int)MainWindow.instance.obj_rot.Value));

            return true;
        }
    }
}
