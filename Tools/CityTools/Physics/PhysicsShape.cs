using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using CityTools.Core;
using Box2CS;

namespace CityTools.Physics {
    public enum PhysicsShapes {
        Rectangle,
        Circle,
        Edge
    }
    
    public class PhysicsShape : ObjectSystem.BaseObject {
        public PhysicsShapes myShape;
        public RectangleF aabb;

        public int physics_ID = 0;

        public PhysicsShape(RectangleF aabb, Boolean isInWorld) : base() {
            this.aabb = aabb;

            if (isInWorld) {
                BodyDef bDef = new BodyDef(BodyType.Static, new Vec2(aabb.Left + aabb.Width / 2, aabb.Top + aabb.Height / 2), 0);
                PolygonShape shape = new PolygonShape();
                shape.SetAsBox(aabb.Width / 2, aabb.Height / 2);

                FixtureDef fDef = new FixtureDef(shape);
                fDef.UserData = this;

                this.baseBody = Box2D.B2System.world.CreateBody(bDef);
                baseBody.CreateFixture(fDef);
            }
        }

        public virtual void DrawMe(Graphics gfx, PointF offset, float zoom, Pen outline, Brush middle) { }
    }

    public class PhysicsRectangle : PhysicsShape {
        public PhysicsRectangle(RectangleF size, Boolean isInWorld) : base(size, isInWorld) {
                myShape = PhysicsShapes.Rectangle;
        }

        public override void DrawMe(Graphics gfx, PointF offset, float zoom, Pen outline, Brush middle) {
            gfx.FillRectangle(middle, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Height * zoom);
            gfx.DrawRectangle(outline, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Height * zoom);
        }
    }

    public class PhysicsCircle : PhysicsShape {
        public PhysicsCircle(RectangleF size, Boolean isInWorld) : base(size, isInWorld) {
            myShape = PhysicsShapes.Circle;
        }

        public override void DrawMe(Graphics gfx, PointF offset, float zoom, Pen outline, Brush middle) {
            gfx.FillEllipse(middle, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Width * zoom);
            gfx.DrawEllipse(outline, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Width * zoom);
        }
    }

    public class PhysicsEdge : PhysicsShape {
        public PointF p0;
        public PointF p1;

        public PhysicsEdge(RectangleF size, Boolean isInWorld)
            : base(GenerateAABB(size), isInWorld) {
            myShape = PhysicsShapes.Edge;

            p0 = size.Location;
            p1 = size.Size.ToPointF();
        }

        public override void DrawMe(Graphics gfx, PointF offset, float zoom, Pen outline, Brush middle) {
            gfx.DrawLine(outline, (p0.X - offset.X) * zoom, (p0.Y - offset.Y) * zoom, (p1.X - offset.X) * zoom, (p1.Y - offset.Y) * zoom);
        }

        public static RectangleF GenerateAABB(RectangleF size) {
            PointF p0a = new PointF(Math.Min(size.Left, size.Width), Math.Min(size.Top, size.Height));
            SizeF p1a = new SizeF(Math.Abs(size.Left - size.Width), Math.Abs(size.Top - size.Height));

            p0a.X = (p0a.X + Camera.Offset.X) * Camera.ZoomLevel;
            p0a.Y = (p0a.Y + Camera.Offset.Y) * Camera.ZoomLevel;
            p1a.Width = p1a.Width * Camera.ZoomLevel;
            p1a.Height = p1a.Height * Camera.ZoomLevel;

            return new RectangleF(p0a, p1a);
        }
    }

}
