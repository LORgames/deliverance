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

            NodeCache.AddNode(new Node(p0.X, p0.Y, MainWindow.instance.cmbNodeStyle.SelectedIndex));

            return true;
        }

        public static void DrawNodes(LBuffer buffer) {
            // Draw nodes
            drawList = new List<Node>();

            RectangleF drawArea = Camera.ViewArea;

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeDrawer.QCBD), new AABB(new Box2CS.Vec2(drawArea.Left, drawArea.Top), new Vec2(drawArea.Right, drawArea.Bottom)));

            foreach (KeyValuePair<int, Node> pair in NodeCache.nodes) {
                for (int i = 0; i < pair.Value.children.Count; i++) {
                    if (NodeCache.nodes.ContainsKey(pair.Value.children[i])) {
                        if (drawList.Contains(NodeCache.nodes[pair.Value.children[i]])) {
                            drawList.Add(pair.Value);
                        }
                    } else {
                        pair.Value.children.RemoveAt(i);
                        i--;
                    }
                }
            }

            drawList.Sort();

            foreach (Node node in drawList) {
                node.Draw(buffer);
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
