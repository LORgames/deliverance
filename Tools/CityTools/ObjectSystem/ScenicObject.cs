using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Box2CS;

namespace CityTools.ObjectSystem {
    public class ScenicObject : BaseObject {
        public string source = "";
        public int angle = 0;

        public ScenicObject selected = null;

        public PointF[] points;

        public ScenicObject(string source, PointF initialLocation, int angle) {
            this.angle = angle;
            this.source = source;

            Image im_o = ImageCache.RequestImage(source);
            Image im_a = ImageCache.RequestImage(source, angle);

            initialLocation.X = (int)(initialLocation.X);
            initialLocation.Y = (int)(initialLocation.Y);

            BodyDef bDef = new BodyDef(BodyType.Static, new Vec2(initialLocation.X, initialLocation.Y), 0);
            PolygonShape shape = new PolygonShape();
            shape.SetAsBox(im_o.Width / 2, im_o.Height / 2, Vec2.Empty, angle * (float)Math.PI / 180);

            //^^
            //Original the center position above was: new Vec2(im_o.Width / 2, im_o.Height / 2)

            points = new PointF[shape.VertexCount];

            for (int i = 0; i < shape.VertexCount; i++) {
                Vec2 vertex = shape.Vertices[i];
                points[i] = new PointF(vertex.X + initialLocation.X, vertex.Y + initialLocation.Y);
            }

            FixtureDef fDef = new FixtureDef(shape);
            fDef.UserData = this;

            this.baseBody = Box2D.B2System.world.CreateBody(bDef);
            baseBody.CreateFixture(fDef);
        }

        public override void Draw(LBuffer buffer, RectangleF drawArea, float ZoomFactor, bool drawBoundingBoxes) {
            Image im = ImageCache.RequestImage(source, angle);

            float p0x = ((baseBody.Position.X - drawArea.Left) - (im.Width / 2)) * ZoomFactor;
            float p0y = ((baseBody.Position.Y - drawArea.Top) - (im.Height / 2)) * ZoomFactor;

            float p1x = im.Width * ZoomFactor;
            float p1y = im.Height * ZoomFactor;

            buffer.gfx.DrawImage(im, p0x, p0y, p1x, p1y);

            if (drawBoundingBoxes) {
                PointF[] realignedPoints = new PointF[points.Length];
                points.CopyTo(realignedPoints, 0);

                for (int i = 0; i < realignedPoints.Length; i++) {
                    realignedPoints[i].X = (points[i].X - drawArea.Left) * ZoomFactor;
                    realignedPoints[i].Y = (points[i].Y - drawArea.Top) * ZoomFactor;
                }

                buffer.gfx.FillPolygon(new SolidBrush(Color.FromArgb(64, Color.Yellow)), realignedPoints);
                buffer.gfx.DrawPolygon(new Pen(Color.Yellow), realignedPoints);
            }
        }
    }
}
