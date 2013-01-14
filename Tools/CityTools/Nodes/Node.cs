using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Box2CS;
using CityTools.Core;
using System.Drawing;

namespace CityTools.Nodes {
    class Node : IComparable<Node> {
        //Circular references
        public Body baseBody;

        // For indexing
        internal static short CURRENT_INDEX = 0;
        public short index = 0;

        internal float x;
        internal float y;

        internal const float RADIUS = 4.0f;

        public Node(float x, float y) {
            index = CURRENT_INDEX++;

            this.x = x;
            this.y = y;

            BodyDef bDef = new BodyDef(BodyType.Static, new Vec2(x, y), 0);
            CircleShape shape = new CircleShape(Vec2.Empty, RADIUS);

            //^^
            //Original the center position above was: new Vec2(im_o.Width / 2, im_o.Height / 2)

            FixtureDef fDef = new FixtureDef(shape);
            fDef.UserData = this;

            this.baseBody = Box2D.B2System.world.CreateBody(bDef);
            baseBody.CreateFixture(fDef);
        }

        public void Draw(LBuffer buffer) {
            float realignedX = (x - RADIUS) * Camera.ZoomLevel - Camera.ViewArea.Left;
            float realignedY = (y - RADIUS) * Camera.ZoomLevel - Camera.ViewArea.Top;

            buffer.gfx.FillEllipse(new SolidBrush(Color.FromArgb(64, Color.Yellow)), realignedX, realignedY, RADIUS * 2.0f * Camera.ZoomLevel, RADIUS * 2.0f * Camera.ZoomLevel);
            buffer.gfx.DrawEllipse(new Pen(Color.Yellow), realignedX, realignedY, RADIUS * 2.0f * Camera.ZoomLevel, RADIUS * 2.0f * Camera.ZoomLevel);
        }

        public void Delete() {
            // Remove from NodeCache
            NodeCache.nodes.Remove(index);

            // Remove from world
            Box2D.B2System.world.DestroyBody(baseBody);
        }

        public int CompareTo(Node other) {
            return index.CompareTo(other.index);
        }
    }
}
