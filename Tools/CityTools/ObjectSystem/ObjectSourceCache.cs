using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace CityTools.ObjectSystem {
    public class ObjectSourceCache {

        private static Dictionary<String, Image> img_store = new Dictionary<string, Image>();

        public static Image RequestImage(string filename) {
            if (img_store.ContainsKey(filename)) {
                return img_store[filename];
            }

            img_store.Add(filename, Image.FromFile(filename));
            return img_store[filename];
        }

    }
}
