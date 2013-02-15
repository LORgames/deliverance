using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace CityTools.Core {
    public class Camera {
        public static PointF Offset = Point.Empty;
        public static RectangleF ViewArea = new Rectangle();
        public static float ZoomLevel = 1.0f;

        public static void FixViewArea(Rectangle drawArea) {
            System.Diagnostics.Debug.WriteLine("CZ: " + ZoomLevel);

            if (Offset.X < 0.0f) Offset.X = 0.0f;
            if (Offset.X > MainWindow.MAP_SIZE_X - drawArea.Width / ZoomLevel) Offset.X = MainWindow.MAP_SIZE_X - drawArea.Width / ZoomLevel;

            if (Offset.Y < 0.0f) Offset.Y = 0.0f;
            if (Offset.Y > MainWindow.MAP_SIZE_Y - drawArea.Height / ZoomLevel) Offset.Y = MainWindow.MAP_SIZE_Y - drawArea.Height / ZoomLevel;

            Offset.X = (float)Math.Round(Offset.X);
            Offset.Y = (float)Math.Round(Offset.Y);

            ViewArea = new RectangleF(Offset, new Size((int)(drawArea.Width / ZoomLevel), (int)(drawArea.Height / ZoomLevel)));
        }

        public static bool ProcessKeys(Keys keyData) {
            if (keyData == Keys.W || keyData == Keys.A || keyData == Keys.S || keyData == Keys.D || keyData == Keys.Q || keyData == Keys.E) {
                if (keyData == Keys.W) {
                    Offset.Y -= 100 / ZoomLevel;
                } else if (keyData == Keys.A) {
                    Offset.X -= 100 / ZoomLevel;
                } else if (keyData == Keys.S) {
                    Offset.Y += 100 / ZoomLevel;
                } else if (keyData == Keys.D) {
                    Offset.X += 100 / ZoomLevel;
                } else if (keyData == Keys.Q) {
                    ZoomLevel *= 0.98f;
                } else if (keyData == Keys.E) {
                    ZoomLevel *= 1.02f;
                }

                if (ZoomLevel < 0.01f) ZoomLevel = 0.01f;
                if (ZoomLevel > 1.0f) ZoomLevel = 1.0f;

                return true;
            }

            return false;
        }
    }
}
