using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace CityTools {
    public class ImageCache {

        private static Dictionary<String, Image> img_store = new Dictionary<string, Image>();

        public static Image RequestImage(string filename) {
            return RequestImage(filename, 0);
        }

        public static Image RequestImage(string filename, int rotation) {
            string cacheName = String.Format("{0}_{1}", filename, rotation);

            //Hopefully more often then not its already cached :)
            if (img_store.ContainsKey(cacheName)) {
                return img_store[cacheName];
            }

            //If its not cached, then boohoo...
            if (rotation == 0) {
                img_store.Add(cacheName, Image.FromFile(filename)); //(well that was easy)
            } else {
                Image original = RequestImage(filename); //Pretty much HAS to be always cached anyway
                Bitmap imToCache;

                DrawingHelper.FixObjectPaintingTransformation(rotation, original, out imToCache);

                img_store.Add(cacheName, imToCache);
            }

            return img_store[cacheName];
        }
    }
}
