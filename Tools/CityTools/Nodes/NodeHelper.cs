using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using CityTools.Core;
using Box2CS;

namespace CityTools.Nodes {
    class NodeHelper {
        private static List<Node> selectedNodes = new List<Node>();

        private static List<int> nodeLinks = new List<int>();

        private static PointF p0 = Point.Empty;
        private static PointF p1 = Point.Empty;

        private static float BASIC_MOVE = 1.0f;
        private static float SHIFT_MOVE = 5.0f;

        public static void MouseDown(MouseEventArgs e) {
            // Clear out the node links and selected nodes
            nodeLinks = new List<int>(); // Create a new list, NodeCache references the previous one after MouseUp
            selectedNodes.Clear();

            p0 = e.Location;
            p1 = e.Location;

            PointF p0a = new PointF(Math.Min(p0.X, p1.X) + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) + Camera.ViewArea.Top);
            PointF p1a = new PointF(Math.Max(p0.X, p1.X) + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) + Camera.ViewArea.Top);

            AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeHelper.QCBD), aabb);

            if (selectedNodes.Count != 0) {
                // sort nodes by index
                selectedNodes.Sort();

                // Grab highest node index and store in nodeLinks list
                nodeLinks.Add(selectedNodes[selectedNodes.Count - 1].index);
            }

        }

        public static void MouseUp(MouseEventArgs e) {
            // This should save off the node links
            NodeCache.AddNodeLink(nodeLinks);
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is Node) {
                selectedNodes.Add(fix.UserData as Node);
            }

            return true;
        }

        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            // This should seek nodes and create links

            p0 = e.Location;
            p1 = e.Location;

            PointF p0a = new PointF(Math.Min(p0.X, p1.X) + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) + Camera.ViewArea.Top);
            PointF p1a = new PointF(Math.Max(p0.X, p1.X) + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) + Camera.ViewArea.Top);

            AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeHelper.QCBD), aabb);

            if (selectedNodes.Count != 0) {
                // sort nodes by index
                selectedNodes.Sort();

                // Grab highest node index and store in nodeLinks list
                nodeLinks.Add(selectedNodes[selectedNodes.Count - 1].index);

                return true;
            }

            return false;
        }
    }
}
