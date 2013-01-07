using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace CityTools.Physics {
    public enum PhysicsShapes {
        Rectangle,
        Circle,
        Triangle
    }
    
    public class PhysicsShape {
        public PhysicsShapes myShape;
        public RectangleF aabb;

        public int physics_ID = 0;
        public int last_draw_ID = 0;

        public PhysicsShape(RectangleF aabb) {
            this.aabb = aabb;
        }

        public virtual void DrawMe(Graphics gfx, PointF offset, Pen outline, Brush middle) { }
    }

    public class PhysicsRectangle : PhysicsShape {
        public PhysicsRectangle(RectangleF size)
            : base(size) {
                myShape = PhysicsShapes.Rectangle;
        }

        public override void DrawMe(Graphics gfx, PointF offset, Pen outline, Brush middle) {
            gfx.FillRectangle(PhysicsDrawer.fillBrush, aabb);
            gfx.DrawRectangle(PhysicsDrawer.outlinePen, aabb.Left, aabb.Top, aabb.Width, aabb.Height);
        }
    }

    public class PhysicsCircle : PhysicsShape {
        public PhysicsCircle(RectangleF size)
            : base(size) {
            myShape = PhysicsShapes.Circle;
        }

        public override void DrawMe(Graphics gfx, PointF offset, Pen outline, Brush middle) {
            gfx.FillEllipse(PhysicsDrawer.fillBrush, aabb.Left, aabb.Top, aabb.Width, aabb.Width);
            gfx.DrawEllipse(PhysicsDrawer.outlinePen, aabb.Left, aabb.Top, aabb.Width, aabb.Width);
        }
    }

    public class PhysicsTriangle : PhysicsShape {
        public PhysicsTriangle(Point p0, Point p1, Point p2) : base(GenerateRect(p0, p1, p2)) {
            myShape = PhysicsShapes.Circle;
        }

        private static RectangleF GenerateRect(Point p0, Point p1, Point p2) {
            float minX = (float)Math.Min(Math.Min(p0.X, p1.X), p2.X);
            float minY = (float)Math.Min(Math.Min(p0.Y, p1.Y), p2.Y);
            float maxX = (float)Math.Min(Math.Max(p0.X, p1.X), p2.X);
            float maxY = (float)Math.Min(Math.Max(p0.Y, p1.Y), p2.Y);

            return new RectangleF(minX, minY, maxX - minX, maxY - minY);
        }

        public override void DrawMe(Graphics gfx, PointF offset, Pen outline, Brush middle) {
            //TODO: Implement this
        }
    }

}
