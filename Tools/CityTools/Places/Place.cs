using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CityTools.Places {
    public enum Places {
        Default
    };

    class Place {
        public float x;
        public float y;

        public float rotation;
        public Places type = Places.Default;

        public Place(float x, float y, float rotation, Places type) {
            this.x = x;
            this.y = y;
            this.rotation = rotation;
            this.type = type;
        }
    }
}
