using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using Box2CS;
using CityTools.Core;

namespace CityTools.ObjectSystem {
    public class ObjectHelper {

        private static List<BaseObject> selectedObjects = new List<BaseObject>();

        private static PointF p0 = Point.Empty;
        private static PointF p1 = Point.Empty;

        private static float BASIC_MOVE = 1.0f;
        private static float SHIFT_MOVE = 5.0f;

        public static void MouseDown(MouseEventArgs e) {
            p0 = e.Location;
            p1 = e.Location;
        }

        public static void MouseUp(MouseEventArgs e) {
            selectedObjects.Clear();

            PointF p0a = new PointF(Math.Min(p0.X, p1.X) + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) + Camera.ViewArea.Top);
            PointF p1a = new PointF(Math.Max(p0.X, p1.X) + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) + Camera.ViewArea.Top);

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

        internal static void MoveSelectedObjects(float x, float y) {
            // Iterate over each selected object and move it
            for (int i = 0; i < selectedObjects.Count; i++) {
                selectedObjects[i].Move(x, y);
            }
        }

        internal static void DeleteSelectedObjects() {
            // Iterate over each selected object and delete it
            for (int i = 0; i < selectedObjects.Count; i++) {
                selectedObjects[i].Delete();
            }

            // Clear the list of selected objects, they should all be deleted now.
            selectedObjects.Clear();
        }

        public static bool ProcessCmdKey(ref Message msg, Keys keyData) {
            // Ignore shift, only use actual keys
            Keys noShift = (Keys)keyData & ~Keys.Shift;

            // Is shift held?
            bool hasShift = ((Keys)keyData & Keys.Shift) == Keys.Shift;

            if (noShift == Keys.Left) {
                // Left is negative, hence the -
                MoveSelectedObjects(-(hasShift ? SHIFT_MOVE : BASIC_MOVE), 0.0f);

            } else if (noShift == Keys.Right) {
                // Right is positive
                MoveSelectedObjects((hasShift ? SHIFT_MOVE : BASIC_MOVE), 0.0f);

            } else if (noShift == Keys.Up) {
                // Up is negative, hence the -
                MoveSelectedObjects(0.0f, -(hasShift ? SHIFT_MOVE : BASIC_MOVE));

            } else if (noShift == Keys.Down) {
                // Down is positive
                MoveSelectedObjects(0.0f, (hasShift ? SHIFT_MOVE : BASIC_MOVE));

            } else if (keyData == Keys.Delete) {
                // Pass deleting on!
                DeleteSelectedObjects();
            }


            return true;
        }
    }
}
