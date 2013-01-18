using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CityTools.Core;

namespace CityTools.Places {
    public class PlacesType {
        public int ObjectIndex = 0;
        public string ImageName = "";

        public List<Physics.PhysicsShape> Physics = new List<Physics.PhysicsShape>();

        public PlacesType(int index, string image) {
            this.ObjectIndex = index;
            this.ImageName = image;

            ImageCache.ForceCache(image);
        }
    }
}
