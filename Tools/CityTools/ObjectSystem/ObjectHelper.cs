using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using Box2CS;

namespace CityTools.ObjectSystem {
    public class ObjectHelper {

        private static List<BaseObject> selectedObjects = new List<BaseObject>();

        private static PointF p0 = Point.Empty;
        private static PointF p1 = Point.Empty;

        public static void MouseDown(MouseEventArgs e) {
            p0 = e.Location;
        }

        public static void MouseUp(MouseEventArgs e, Rectangle viewArea, float zoomLevel) {
            selectedObjects.Clear();

            PointF p0a = new PointF(Math.Min(p0.X, p1.X) + viewArea.Left, Math.Min(p0.Y, p1.Y) + viewArea.Top);
            PointF p1a = new PointF(Math.Max(p0.X, p1.X) + viewArea.Left, Math.Max(p0.Y, p1.Y) + viewArea.Top);

            AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(ObjectHelper.QCBD), aabb);

            p0 = Point.Empty;
            p1 = Point.Empty;
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is ScenicObject) {
                selectedObjects.Add(fix.UserData as ScenicObject);
            }

            return true;
        }

        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            if (p0 != Point.Empty) {
                p1 = e.Location;

                inputBuffer.gfx.Clear(Color.Transparent);

                inputBuffer.gfx.FillRectangle(new SolidBrush(Color.FromArgb(32, Color.Fuchsia)), Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));
                inputBuffer.gfx.DrawRectangle(new Pen(Color.Fuchsia), Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));

                return true;
            }

            return false;
        }

    }
}
