using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Box2CS;
using CityTools.Core;
using System.Drawing;

namespace CityTools.Nodes {
    class Node : IComparable<Node> {
        // PENS
        private static Pen[] drawPens = { new Pen(Color.Yellow), new Pen(Color.Red) };
        private static SolidBrush[] drawBrushes = { new SolidBrush(Color.FromArgb(64, Color.Yellow)), new SolidBrush(Color.FromArgb(64, Color.Red)) };

        //Circular references
        public Body baseBody;

        // For indexing
        internal static int CURRENT_INDEX = 0;
        public int index = 0;

        internal int type;

        internal float x;
        internal float y;

        internal const float RADIUS = 4.0f;

        internal List<int> children = new List<int>();

        public Node(float x, float y, int type) {
            index = CURRENT_INDEX++;

            this.x = x;
            this.y = y;
            this.type = type;

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

            buffer.gfx.FillEllipse(drawBrushes[type], realignedX, realignedY, RADIUS * 2.0f * Camera.ZoomLevel, RADIUS * 2.0f * Camera.ZoomLevel);
            buffer.gfx.DrawEllipse(drawPens[type], realignedX, realignedY, RADIUS * 2.0f * Camera.ZoomLevel, RADIUS * 2.0f * Camera.ZoomLevel);

            // Draw links to other nodes, this could probably be done by the node...
            for (int i = 0; i < children.Count; i++) {
                try {
                    PointF from = new PointF();
                    from.X = x * Camera.ZoomLevel - Camera.ViewArea.Left;
                    from.Y = y * Camera.ZoomLevel - Camera.ViewArea.Top;
                    PointF to = new PointF();
                    to.X = NodeCache.nodes[children[i]].x * Camera.ZoomLevel - Camera.ViewArea.Left;
                    to.Y = NodeCache.nodes[children[i]].y * Camera.ZoomLevel - Camera.ViewArea.Top;

                    buffer.gfx.DrawLine(drawPens[type], from, to);
                } catch { }
            }
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
