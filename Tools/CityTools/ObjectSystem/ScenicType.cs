using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CityTools.Core;

namespace CityTools.ObjectSystem {
    public class ScenicType {
        public int ObjectIndex = 0;
        public string ImageName = "";
        public List<Physics.PhysicsShape> Physics = new List<Physics.PhysicsShape>();

        public ScenicType(int index, string image) {
            this.ObjectIndex = index;
            this.ImageName = image;

            ImageCache.ForceCache(image);
        }
    }
}
