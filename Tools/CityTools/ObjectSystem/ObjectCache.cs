using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;
using System.Windows.Forms;

namespace CityTools.ObjectSystem {
    public class ObjectCache {

        public const string SCENIC_DATABASE = Program.CACHE;
        public const string SCENIC_TYPEFILE = SCENIC_DATABASE + "scenic_types.bin";
        public const string SCENIC_USERFILE = SCENIC_DATABASE + "scenic_store.bin";

        private static int _highestTypeIndex = 0;

        public static Dictionary<int, ScenicType> s_objectTypes = new Dictionary<int, ScenicType>();
        public static Dictionary<string, int> s_StringToInt = new Dictionary<string, int>();
        
        public static List<ScenicObject> s_objectStore = new List<ScenicObject>();

        public static void InitializeCache() {
            if (!Directory.Exists(SCENIC_DATABASE)) {
                Directory.CreateDirectory(SCENIC_DATABASE);
            }

            // Load object types from file
            if (File.Exists(SCENIC_TYPEFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(SCENIC_USERFILE));
                int totalShapes = f.GetInt();
                _highestTypeIndex = f.GetInt();

                for (int i = 0; i < totalShapes; i++) {
                    int type_id = f.GetInt();
                    string source = f.GetString();

                    s_objectTypes.Add(type_id, new ScenicType(type_id, source));
                    s_StringToInt.Add(source, type_id);
                }
            }

            //Scan for new objects
            foreach (string filename in Directory.GetFiles(Components.ObjectCacheControl.OBJECT_CACHE_FOLDER, "*.png", SearchOption.AllDirectories)) {
                if (!ImageCache.HasCached(filename)) {
                    _highestTypeIndex++;
                    s_objectTypes.Add(_highestTypeIndex, new ScenicType(_highestTypeIndex, filename));
                    s_StringToInt.Add(filename, _highestTypeIndex);
                }
            }

            // Load object instances from file
            if (File.Exists(SCENIC_USERFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(SCENIC_USERFILE));
                int totalShapes = f.GetInt();

                for (int i = 0; i < totalShapes; i++) {
                    int sourceID = f.GetInt();
                    float locationX = f.GetFloat();
                    float locationY = f.GetFloat();
                    int rotation = f.GetInt();

                    s_objectStore.Add(new ScenicObject(sourceID, new System.Drawing.PointF(locationX, locationY), rotation));
                }
            }
        }

        public static void AddShape(ScenicObject shape) {
            s_objectStore.Add(shape);
        }

        public static void SaveTypes() {
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectTypes.Count);
            f.AddInt(_highestTypeIndex);

            foreach (KeyValuePair<int, ScenicType> kvp in s_objectTypes) {
                f.AddInt(kvp.Key);
                f.AddString(kvp.Value.ImageName);
            }

            f.Encode(SCENIC_TYPEFILE);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectStore.Count);

            foreach (ScenicObject ps in s_objectStore) {
                f.AddInt(ps.object_index);
                f.AddFloat(ps.baseBody.Position.X);
                f.AddFloat(ps.baseBody.Position.Y);
                f.AddInt(ps.angle);
            }

            f.Encode(SCENIC_USERFILE);
        }
    }
}
