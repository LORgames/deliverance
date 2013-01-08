using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Box2CS;

namespace CityTools.Box2D {
    public class B2System {

        public static World world;

        public static void Initialize() {
            world = new World(new Vec2(0, 0), true);
        }

    }
}
