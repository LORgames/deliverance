using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Box2CS;
using CityTools.Core;
using CityTools.Places;
using CityTools.Physics;

namespace CityTools.ObjectSystem {
    public class BaseObjectDrawer {

        public static List<ScenicObject> drawList = new List<ScenicObject>();
        public static List<PlacesObject> drawList2 = new List<PlacesObject>();
        public static List<PhysicsShape> drawList3 = new List<PhysicsShape>();

        public static void DrawObjects(LBuffer buffer0, LBuffer buffer1, LBuffer places, LBuffer physics) {
            drawList.Clear();
            drawList2.Clear();
            drawList3.Clear();

            RectangleF drawArea = Camera.ViewArea;

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(BaseObjectDrawer.QCBD), new AABB(new Box2CS.Vec2(drawArea.Left, drawArea.Top), new Vec2(drawArea.Right, drawArea.Bottom)));

            drawList.Sort();
            drawList2.Sort();

            foreach (ScenicObject obj in drawList) {
                if (ScenicObjectCache.s_objectTypes[obj.object_index].layer == 0) {
                    obj.Draw(buffer0);
                } else {
                    obj.Draw(buffer1);
                }
            }

            foreach (PlacesObject obj in drawList2) {
                obj.Draw(places);
            }

            foreach (PhysicsShape obj in drawList3) {
                obj.DrawMe(physics.gfx, Camera.Offset, Camera.ZoomLevel, PhysicsDrawer.outlinePen, PhysicsDrawer.fillBrush);
            }
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is ScenicObject) {
                drawList.Add(fix.UserData as ScenicObject);
            } else if (fix.UserData is PlacesObject) {
                drawList2.Add(fix.UserData as PlacesObject);
            } else if (fix.UserData is PhysicsShape) {
                drawList3.Add(fix.UserData as PhysicsShape);
            }

            return true;
        }
    }
}
