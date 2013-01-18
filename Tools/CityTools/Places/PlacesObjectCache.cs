using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;
using System.Windows.Forms;
using CityTools.Physics;
using System.Drawing;

namespace CityTools.Places {
    public class PlacesObjectCache {
        public const string PLACES_TYPEFILE = Program.CACHE + "places_types.bin";
        public const string PLACES_USERFILE = Program.CACHE + "places_store.bin";
        public const string PLACES_FOLDER = ".\\Places";

        private static int _highestTypeIndex = 0;

        public static Dictionary<int, PlacesType> s_objectTypes = new Dictionary<int, PlacesType>();
        public static Dictionary<string, int> s_StringToInt = new Dictionary<string, int>();

        public static List<PlacesObject> s_objectStore = new List<PlacesObject>();

        public static void InitializeCache() {
            if (!Directory.Exists(PLACES_FOLDER)) {
                Directory.CreateDirectory(PLACES_FOLDER);
            }

            // Load object types from file
            if (File.Exists(PLACES_TYPEFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(PLACES_TYPEFILE));

                int totalShapes = f.GetInt();
                _highestTypeIndex = f.GetInt();

                //This is where we load the BASIC information
                for (int i = 0; i < totalShapes; i++) {
                    int type_id = f.GetInt();
                    string source = f.GetString();

                    s_objectTypes.Add(type_id, new PlacesType(type_id, source));
                    s_StringToInt.Add(source, type_id);
                }
            }

            //Scan for new objects
            foreach (string filename in Directory.GetFiles(PLACES_FOLDER, "*.png", SearchOption.AllDirectories)) {
                if (!ImageCache.HasCached(filename)) {
                    _highestTypeIndex++;
                    s_objectTypes.Add(_highestTypeIndex, new PlacesType(_highestTypeIndex, filename));
                    s_StringToInt.Add(filename, _highestTypeIndex);
                }
            }

            // Load object instances from file
            if (File.Exists(PLACES_USERFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(PLACES_USERFILE));
                int totalShapes = f.GetInt();

                for (int i = 0; i < totalShapes; i++) {
                    int sourceID = f.GetInt();
                    float locationX = f.GetFloat();
                    float locationY = f.GetFloat();
                    int rotation = f.GetInt();

                    s_objectStore.Add(new PlacesObject(sourceID, new System.Drawing.PointF(locationX, locationY), rotation));
                }
            }
        }

        public static void AddShape(PlacesObject shape) {
            s_objectStore.Add(shape);
        }

        public static void SaveTypes() {
            //Count physics objects first...
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectTypes.Count);
            f.AddInt(_highestTypeIndex);

            foreach (KeyValuePair<int, PlacesType> kvp in s_objectTypes) {
                f.AddInt(kvp.Key);
                f.AddString(kvp.Value.ImageName);
            }

            f.Encode(PLACES_TYPEFILE);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectStore.Count);

            foreach (PlacesObject ps in s_objectStore) {
                f.AddInt(ps.object_index);
                f.AddFloat(ps.baseBody.Position.X);
                f.AddFloat(ps.baseBody.Position.Y);
                f.AddInt(ps.angle);
            }

            f.Encode(PLACES_USERFILE);
        }
    }
}
