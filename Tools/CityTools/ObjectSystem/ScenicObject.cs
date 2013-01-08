using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Box2CS;

namespace CityTools.ObjectSystem {
    public class ScenicObject : BaseObject {
        public string source = "";

        public ScenicObject selected = null;

        public ScenicObject(string source, PointF initialLocation, float angle) {
            BodyDef bDef = new BodyDef(BodyType.Static, new Vec2(initialLocation.X, initialLocation.Y), angle);

            this.source = source;
            Image im = ObjectSourceCache.RequestImage(source);

            PolygonShape shape = new PolygonShape();
            shape.SetAsBox(im.Width, im.Height, new Vec2(im.Width/2, im.Height/2), angle);

            FixtureDef fDef = new FixtureDef(shape);
            fDef.UserData = this;

            this.baseBody = Box2D.B2System.world.CreateBody(bDef);
            baseBody.CreateFixture(fDef);
        }

        public override void Draw(LBuffer buffer, RectangleF drawArea) {
            Image im = ObjectSourceCache.RequestImage(source);

            float p0x = baseBody.Position.X - drawArea.Left;
            float p0y = baseBody.Position.Y - drawArea.Top;

            //TODO: Figure this bit out...
            float p1x = im.Width;
            float p1y = im.Height;

            buffer.gfx.DrawImage(im, p0x, p0y, p1x, p1y);
        }
    }
}
