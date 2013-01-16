using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using Box2CS;
using CityTools.Core;

namespace CityTools.ObjectSystem {
    public class ScenicDrawer {

        public static List<ScenicObject> drawList;

        public static void DrawScenicObjects(LBuffer buffer, bool drawBoundingBoxes) {
            drawList = new List<ScenicObject>();

            RectangleF drawArea = Camera.ViewArea;

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(ScenicDrawer.QCBD), new AABB(new Box2CS.Vec2(drawArea.Left, drawArea.Top), new Vec2(drawArea.Right, drawArea.Bottom)));

            drawList.Sort();
            foreach (ScenicObject obj in drawList) {
                obj.Draw(buffer, drawBoundingBoxes);
            }
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is ScenicObject) {
                drawList.Add(fix.UserData as ScenicObject);
            }
            return true;
        }
    }
}
