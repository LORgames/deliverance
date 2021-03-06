﻿using System;
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

        private static int lastNodeIndex = -1;

        private static PointF p0 = Point.Empty;
        private static PointF p1 = Point.Empty;

        private static float BASIC_MOVE = 1.0f;
        private static float SHIFT_MOVE = 5.0f;

        public static void MouseDown(MouseEventArgs e) {
            // Clear out the node links and selected nodes
            selectedNodes.Clear();

            p0 = e.Location;
            p1 = e.Location;

            PointF p0a = new PointF(Math.Min(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);
            PointF p1a = new PointF(Math.Max(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);

            AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeHelper.QCBD), aabb);

            if (selectedNodes.Count != 0) {
                // sort nodes by index
                selectedNodes.Sort();

                // Grab highest node index and set the last node index
                lastNodeIndex = selectedNodes[selectedNodes.Count - 1].index;
            }

        }

        public static void MouseUp(MouseEventArgs e) {
            // Kill the lastNodeIndex to stop UpdateMouse from creating links
            lastNodeIndex = -1;
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is Node) {
                if ((fix.UserData as Node).type == MainWindow.instance.cmbNodeStyle.SelectedIndex) {
                    selectedNodes.Add(fix.UserData as Node);
                }
            }

            return true;
        }

        internal static bool UpdateMouse(MouseEventArgs e, LBuffer inputBuffer) {
            if (e.Button == MouseButtons.Left) {
                // Clear out the selectedNodes list
                selectedNodes.Clear();

                // This should seek nodes and create links

                p0 = e.Location;
                p1 = e.Location;

                PointF p0a = new PointF(Math.Min(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);
                PointF p1a = new PointF(Math.Max(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);

                AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

                Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeHelper.QCBD), aabb);

                if (selectedNodes.Count != 0 && lastNodeIndex != -1) {
                    // sort nodes by index
                    selectedNodes.Sort();

                    // Grab highest node index and create the link
                    NodeCache.AddNodeLink(NodeCache.nodes[lastNodeIndex], selectedNodes[selectedNodes.Count - 1]);

                    // Update last node index
                    lastNodeIndex = selectedNodes[selectedNodes.Count - 1].index;

                    return true;
                }
            }

            return false;
        }

        public static void MouseDown_Selector(MouseEventArgs e) {
            p0 = e.Location;
            p1 = e.Location;
        }

        public static void MouseUp_Selector(MouseEventArgs e) {
            selectedNodes.Clear();

            PointF p0a = new PointF(Math.Min(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Min(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);
            PointF p1a = new PointF(Math.Max(p0.X, p1.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Max(p0.Y, p1.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);

            AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(NodeHelper.QCBD), aabb);

            // If p0 and p1 are the same or the event was triggered by right clicking, only select the top object
            if (p0 == p1) {
                int highestIndex = -1; // Highest index 

                // Locate the highest index
                for (int i = 0; i < selectedNodes.Count; i++) {

                    // If current objects index is higher, store it as the highest index
                    if (selectedNodes[i].index > highestIndex) {
                        highestIndex = selectedNodes[i].index;
                    }
                }

                // Remove all other objects
                for (int i = 0; i < selectedNodes.Count; i++) {
                    if (selectedNodes[i].index != highestIndex) {
                        selectedNodes.RemoveAt(i);
                        i--;
                    }
                }
            }

            p0 = Point.Empty;
            p1 = Point.Empty;
        }

        internal static bool UpdateMouse_Selector(MouseEventArgs e, LBuffer inputBuffer) {
            if (p0 != Point.Empty) {
                p1 = e.Location;

                inputBuffer.gfx.Clear(Color.Transparent);

                inputBuffer.gfx.FillRectangle(new SolidBrush(Color.FromArgb(32, Color.Fuchsia)), Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));
                inputBuffer.gfx.DrawRectangle(new Pen(Color.Fuchsia), Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));

                return true;
            }

            return false;
        }

        internal static void MoveSelectedObjects(float x, float y) {
            // Iterate over each selected object and move it
            for (int i = 0; i < selectedNodes.Count; i++) {
                selectedNodes[i].Move(x, y);
            }
        }

        internal static void DeleteSelectedObjects() {
            // Iterate over each selected object and delete it
            for (int i = 0; i < selectedNodes.Count; i++) {
                selectedNodes[i].Delete();
            }

            // Clear the list of selected objects, they should all be deleted now.
            selectedNodes.Clear();
        }

        public static bool ProcessCmdKey(ref Message msg, Keys keyData) {
            // Ignore shift, only use actual keys
            Keys noShift = (Keys)keyData & ~Keys.Shift;

            // Is shift held?
            bool hasShift = ((Keys)keyData & Keys.Shift) == Keys.Shift;

            if (noShift == Keys.Left) {
                // Left is negative, hence the -
                MoveSelectedObjects(-(hasShift ? SHIFT_MOVE : BASIC_MOVE), 0.0f);

            } else if (noShift == Keys.Right) {
                // Right is positive
                MoveSelectedObjects((hasShift ? SHIFT_MOVE : BASIC_MOVE), 0.0f);

            } else if (noShift == Keys.Up) {
                // Up is negative, hence the -
                MoveSelectedObjects(0.0f, -(hasShift ? SHIFT_MOVE : BASIC_MOVE));

            } else if (noShift == Keys.Down) {
                // Down is positive
                MoveSelectedObjects(0.0f, (hasShift ? SHIFT_MOVE : BASIC_MOVE));

            } else if (keyData == Keys.Delete) {
                // Pass deleting on!
                DeleteSelectedObjects();
            }

            return true;
        }
    }
}
