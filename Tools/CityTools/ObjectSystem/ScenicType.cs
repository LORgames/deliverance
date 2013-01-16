using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CityTools.Core;

namespace CityTools.ObjectSystem {
    public class ScenicType {
        public int ObjectIndex = 0;
        public string ImageName = "";
        public byte layer = 0;

        public List<Physics.PhysicsShape> Physics = new List<Physics.PhysicsShape>();

        public ScenicType(int index, string image, byte layer) {
            this.ObjectIndex = index;
            this.ImageName = image;
            this.layer = layer;

            ImageCache.ForceCache(image);
        }
    }
}
