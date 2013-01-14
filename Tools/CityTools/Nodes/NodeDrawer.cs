using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using CityTools.Core;
using Box2CS;

namespace CityTools.Nodes {
    class NodeDrawer {

        public static List<Node> drawList;
        private static Point mousePos = Point.Empty;

        internal static bool MouseDown(MouseEventArgs e, LBuffer input_buffer) {
            mousePos = e.Location;

            RectangleF viewArea = Camera.ViewArea;

            PointF p0 = new PointF(mousePos.X / Camera.ZoomLevel + viewArea.Left, mousePos.Y / Camera.ZoomLevel + viewArea.Top);

            NodeCache.AddNode(new Node(p0.X, p0.Y));

            return true;
        }

        public static void DrawNodes(LBuffer buffer) {
            // Draw nodes
            drawList = new List<Node>();

            RectangleF drawArea = Camera.ViewArea;

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeDrawer.QCBD), new AABB(new Box2CS.Vec2(drawArea.Left, drawArea.Top), new Vec2(drawArea.Right, drawArea.Bottom)));

            drawList.Sort();

            foreach (Node node in drawList) {
                node.Draw(buffer);
            }

            // Draw node links
            // For each node link list
            for (int i = 0; i < NodeCache.nodeLinks.Count; i++) {
                List<PointF> points = new List<PointF>();

                // for each node in a node link list
                for (int j = 0; j < NodeCache.nodeLinks[i].Count; j++) {
                    // Find the x and y values of the node
                    float x = NodeCache.nodes[NodeCache.nodeLinks[i][j]].x * Camera.ZoomLevel - Camera.ViewArea.Left;
                    float y = NodeCache.nodes[NodeCache.nodeLinks[i][j]].y * Camera.ZoomLevel - Camera.ViewArea.Top;

                    points.Add(new PointF(x, y));
                }

                // Draw a line for each node link
                for (int j = 0; j < points.Count -1; j++) {
                    buffer.gfx.DrawLine(new Pen(Color.Yellow), points[j], points[j + 1]);
                }
            }
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is Node) {
                drawList.Add(fix.UserData as Node);
            }

            return true;
        }
    }
}
