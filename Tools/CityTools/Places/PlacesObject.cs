using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Box2CS;
using CityTools.Core;
using CityTools.ObjectSystem;

namespace CityTools.Places {
    public class PlacesObject : BaseObject {
        private string source = ""; //Just caching it really, prevents a lookup later
        public int object_index = 0;
        public int angle = 0;

        public bool selected = false;

        public PointF[] points;

        public PlacesObject(int obj_index, PointF initialLocation, int angle) : base() {
            this.angle = angle;

            this.object_index = obj_index;
            this.source = PlacesObjectCache.s_objectTypes[obj_index].ImageName;

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

        public override void Draw(LBuffer buffer) {
            Image im = ImageCache.RequestImage(source, angle);

            float p0x = ((baseBody.Position.X - Camera.ViewArea.Left) - (im.Width / 2)) * Camera.ZoomLevel;
            float p0y = ((baseBody.Position.Y - Camera.ViewArea.Top) - (im.Height / 2)) * Camera.ZoomLevel;

            float p1x = im.Width * Camera.ZoomLevel;
            float p1y = im.Height * Camera.ZoomLevel;

            buffer.gfx.DrawImage(im, p0x, p0y, p1x, p1y);

            if (selected) {
                PointF[] realignedPoints = new PointF[points.Length];
                points.CopyTo(realignedPoints, 0);

                for (int i = 0; i < realignedPoints.Length; i++) {
                    realignedPoints[i].X = (points[i].X - Camera.ViewArea.Left) * Camera.ZoomLevel;
                    realignedPoints[i].Y = (points[i].Y - Camera.ViewArea.Top) * Camera.ZoomLevel;
                }

                buffer.gfx.FillPolygon(new SolidBrush(Color.FromArgb(64, Color.Yellow)), realignedPoints);
                buffer.gfx.DrawPolygon(new Pen(Color.Yellow), realignedPoints);
            }
        }

        public override void Move(float x, float y) {
            // Move each point
            for (int i = 0; i < points.Length; i++) {
                points[i].X += x;
                points[i].Y += y;
            }

            // Move the physics object for future selections
            baseBody.Position = new Vec2(baseBody.Position.X + x, baseBody.Position.Y + y);
        }

        public override void Delete() {
            // Remove from ObjectCache
            for (int i = 0; i < PlacesObjectCache.s_objectStore.Count; i++) {
                if (PlacesObjectCache.s_objectStore[i] == this) {
                    PlacesObjectCache.s_objectStore.RemoveAt(i);
                    i--;
                }
            }

            // Remove from ObjectDrawer
            for (int i = 0; i < BaseObjectDrawer.drawList2.Count; i++) {
                if (BaseObjectDrawer.drawList2[i] == this) {
                    BaseObjectDrawer.drawList2.RemoveAt(i);
                    i--;
                }
            }

            // Remove from world
            Box2D.B2System.world.DestroyBody(baseBody);
        }
    }
}
