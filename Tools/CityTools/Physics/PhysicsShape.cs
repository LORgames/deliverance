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
        Circle
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
            gfx.FillRectangle(PhysicsDrawer.fillBrush, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Height * zoom);
            gfx.DrawRectangle(PhysicsDrawer.outlinePen, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Height * zoom);
        }
    }

    public class PhysicsCircle : PhysicsShape {
        public PhysicsCircle(RectangleF size, Boolean isInWorld) : base(size, isInWorld) {
            myShape = PhysicsShapes.Circle;
        }

        public override void DrawMe(Graphics gfx, PointF offset, float zoom, Pen outline, Brush middle) {
            gfx.FillEllipse(PhysicsDrawer.fillBrush, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Width * zoom);
            gfx.DrawEllipse(PhysicsDrawer.outlinePen, (aabb.Left - offset.X) * zoom, (aabb.Top - offset.Y) * zoom, aabb.Width * zoom, aabb.Width * zoom);
        }
    }

}
