using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Box2CS;
using CityTools.Core;
using CityTools.Places;

namespace CityTools.ObjectSystem {
    public class BaseObjectDrawer {

        public static List<ScenicObject> drawList = new List<ScenicObject>();
        public static List<PlacesObject> drawList2 = new List<PlacesObject>();

        public static void DrawObjects(LBuffer buffer0, LBuffer buffer1, LBuffer places) {
            drawList.Clear();
            drawList2.Clear();

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
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is ScenicObject) {
                drawList.Add(fix.UserData as ScenicObject);
            } else if (fix.UserData is PlacesObject) {
                drawList2.Add(fix.UserData as PlacesObject);
            }

            return true;
        }
    }
}
