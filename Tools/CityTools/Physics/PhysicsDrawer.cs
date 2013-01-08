using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;

namespace CityTools.Physics {
    public class PhysicsDrawer {

        public static PhysicsShapes drawingShape = PhysicsShapes.Rectangle;

        public static LBuffer physicsBuffer;

        private static bool downBefore = false;
        private static PointF p0 = Point.Empty;
        private static PointF p1 = Point.Empty;
        private static PointF p2 = Point.Empty;

        private static int redrawID = 0;
        private static PointF offset;

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
                case "phys_add_triangle":
                    drawingShape = PhysicsShapes.Triangle;
                    break;
                default:
                    MessageBox.Show("Unknown shape: " + btnName);
                    break;
            }
        }

        //return true if input layer needs a redraw :)
        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            if (drawingShape != PhysicsShapes.Triangle) {
                if (e.Button == MouseButtons.Left && !downBefore) {
                    p0 = e.Location;
                    downBefore = true;
                } else if (p0 != Point.Empty) {
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
            }

            return false;
        }

        internal static void ReleaseMouse(MouseEventArgs e) {
            if (downBefore) {
                if (drawingShape == PhysicsShapes.Rectangle) {
                    PhysicsCache.AddShape(new PhysicsRectangle(new RectangleF(Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y))));
                } else if(drawingShape == PhysicsShapes.Circle) {
                    PhysicsCache.AddShape(new PhysicsCircle(new RectangleF(Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.X - p0.X))));
                }

                p0 = Point.Empty;
                p1 = Point.Empty;
                downBefore = false;
            }
        }

        internal static void RedrawBuffer(float offsetX, float offsetY, float offsetZ) {
            redrawID++;

            //Find valid chunks

            offset = new PointF(offsetX, offsetY);

            foreach (PhysicsShape shape in PhysicsCache.shapes) {
                shape.DrawMe(physicsBuffer.gfx, offset, outlinePen, fillBrush);
                shape.last_draw_ID = redrawID;
            }
        }

        internal static void DrawShape(PhysicsShape shape) {
            shape.DrawMe(physicsBuffer.gfx, offset, outlinePen, fillBrush);
        }
    }
}
