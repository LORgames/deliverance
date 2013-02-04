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

        private static List<PhysicsShape> selectedObjects = new List<PhysicsShape>();

        private static List<PhysicsShape> drawList = new List<PhysicsShape>();

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
                case "phys_add_edge":
                    drawingShape = PhysicsShapes.Edge;
                    break;
                case "phys_delete":
                    drawingShape = PhysicsShapes.Delete;
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
                } else if (drawingShape == PhysicsShapes.Edge) {
                    inputBuffer.gfx.DrawLine(outlinePen_draft, p0, p1);
                }

                return true;
            }

            return false;
        }

        internal static void MouseDown(MouseEventArgs e, LBuffer input_buffer) {
            p0 = e.Location;
        }

        internal static void ReleaseMouse(MouseEventArgs e) {
            if (drawingShape != PhysicsShapes.Delete) {
                if (Math.Floor(p0.X) == Math.Floor(p1.X)) return;
                if (Math.Floor(p0.Y) == Math.Floor(p1.Y)) return;
            } else {
                p1 = e.Location;
            }

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
            } else if (drawingShape == PhysicsShapes.Edge) {
                p0a.X = (p0.X + Camera.Offset.X) * Camera.ZoomLevel;
                p0a.Y = (p0.Y + Camera.Offset.Y) * Camera.ZoomLevel;

                p1a.Width = (p1.X + Camera.Offset.X) * Camera.ZoomLevel;
                p1a.Height = (p1.Y + Camera.Offset.Y) * Camera.ZoomLevel;

                PhysicsCache.AddShape(new PhysicsEdge(new RectangleF(p0a, p1a), true));
            } else if (drawingShape == PhysicsShapes.Delete) {
                if (p0 == p1) {
                    PointF p0b = new PointF(Math.Min(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);
                    PointF p1b = new PointF(Math.Max(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);

                    AABB aabb = new AABB(new Vec2(p0b.X, p0b.Y), new Vec2(p1b.X, p1b.Y));
                    selectedObjects.Clear();
                    Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(PhysicsDrawer.QCBD), aabb);

                    for (int i = 0; i < selectedObjects.Count; i++) {
                        PhysicsCache.shapes.Remove(selectedObjects[i]);
                        Box2D.B2System.world.DestroyBody(selectedObjects[i].baseBody); // win button
                    }
                }
            }

            p0 = Point.Empty;
            p1 = Point.Empty;
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is PhysicsShape) {
                selectedObjects.Add(fix.UserData as PhysicsShape);
            }

            return true;
        }
    }
}
