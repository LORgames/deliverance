using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using CityTools.Core;

namespace CityTools.Places {
    class PlacesPlacementHelper {
        private static Point mousePos = Point.Empty;

        public static int object_index = 0;

        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            mousePos = e.Location;

            RectangleF effectedArea = new RectangleF(mousePos.X - (MainWindow.instance.obj_paint_image.Width * Camera.ZoomLevel / 2), mousePos.Y - (MainWindow.instance.obj_paint_image.Height * Camera.ZoomLevel / 2), MainWindow.instance.obj_paint_image.Width * Camera.ZoomLevel, MainWindow.instance.obj_paint_image.Height * Camera.ZoomLevel);

            Rectangle eD = new Rectangle((int)effectedArea.Left, (int)effectedArea.Top, (int)Math.Round(effectedArea.Width), (int)Math.Round(effectedArea.Height));

            inputBuffer.gfx.Clear(Color.Transparent);
            inputBuffer.gfx.DrawImage(MainWindow.instance.obj_paint_image, eD);

            return false;
        }

        internal static bool MouseDown(MouseEventArgs e, LBuffer input_buffer) {
            mousePos = e.Location;

            RectangleF viewArea = Camera.ViewArea;

            PointF p0 = new PointF(mousePos.X / Camera.ZoomLevel + viewArea.Left, mousePos.Y / Camera.ZoomLevel + viewArea.Top);

            PointF p1 = PointF.Empty;
            p1.X = MainWindow.instance.obj_paint_image.Width * Camera.ZoomLevel;
            p1.Y = MainWindow.instance.obj_paint_image.Height * Camera.ZoomLevel;

            RectangleF eA = new RectangleF(p0.X, p0.Y, p1.X, p1.Y);
            PlacesObjectCache.AddShape(new PlacesObject(object_index, new PointF(eA.Left, eA.Top), (int)MainWindow.instance.obj_rot.Value));

            return true;
        }
    }
}
