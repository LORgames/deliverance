using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CityTools.Physics {
    public class PhysicsChunk {

        List<int> shapesContainedHere = new List<int>();

        public void Release() {
            shapesContainedHere.Clear();
        }

    }
}
