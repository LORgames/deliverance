using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using CityTools.Core;
using CityTools.ObjectSystem;
using Box2CS;

namespace CityTools.Physics {
    public class PhysicsDrawer {

        public static PhysicsShapes drawingShape = PhysicsShapes.Rectangle;

        private static List<Physics.PhysicsShape> drawList = new List<PhysicsShape>();

        private static PointF p0 = Point.Empty;
        private static PointF p1 = Point.Empty;

        public static Pen outlinePen = new Pen(new SolidBrush(Color.Magenta));
        public static Brush fillBrush = new SolidBrush(Color.FromArgb(128, Color.Magenta));

        private static Pen outlinePen_draft = new Pen(new SolidBrush(Color.Green));
        private static Brush fillBrush_draft = new SolidBrush(Color.FromArgb(128, Color.Green));

        public static void SetShape(string btnName) {
            switch (btnName) {
                case "phys_add_rect":
                    drawingShape = PhysicsShapes.Rectangle;
                    break;
                case "phys_add_ellipse":
                    drawingShape = PhysicsShapes.Circle;
                    break;
            }
        }

        //return true if input layer needs a redraw :)
        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            if (p0 != Point.Empty) {
                inputBuffer.gfx.Clear(Color.Transparent);

                p1 = e.Location;

                if (drawingShape == PhysicsShapes.Rectangle) {
                    inputBuffer.gfx.FillRectangle(fillBrush_draft, Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));
                    inputBuffer.gfx.DrawRectangle(outlinePen_draft, Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));
                } else if (drawingShape == PhysicsShapes.Circle) {
                    inputBuffer.gfx.FillEllipse(fillBrush_draft, Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.X - p0.X));
                    inputBuffer.gfx.DrawEllipse(outlinePen_draft, Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.X - p0.X));
                }

                return true;
            }

            return false;
        }

        internal static void MouseDown(MouseEventArgs e, LBuffer input_buffer) {
            p0 = e.Location;
        }

        internal static void ReleaseMouse(MouseEventArgs e) {
            if (Math.Floor(p0.X) == Math.Floor(p1.X)) return;
            if (Math.Floor(p0.Y) == Math.Floor(p1.Y)) return;

            PointF p0a = new PointF(Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y));
            SizeF p1a = new SizeF(Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));

            p0a.X = (p0a.X + Camera.Offset.X) * Camera.ZoomLevel;
            p0a.Y = (p0a.Y + Camera.Offset.Y) * Camera.ZoomLevel;
            p1a.Width = p1a.Width * Camera.ZoomLevel;
            p1a.Height = p1a.Height * Camera.ZoomLevel;

            if (drawingShape == PhysicsShapes.Rectangle) {
                PhysicsCache.AddShape(new PhysicsRectangle(new RectangleF(p0a, p1a), true));
            } else if(drawingShape == PhysicsShapes.Circle) {
                PhysicsCache.AddShape(new PhysicsCircle(new RectangleF(p0a, p1a), true));
            }

            p0 = Point.Empty;
            p1 = Point.Empty;
        }
    }
}
