using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;
using System.Windows.Forms;
using CityTools.Physics;
using System.Drawing;

namespace CityTools.ObjectSystem {
    public class ScenicObjectCache {

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
                BinaryIO f = new BinaryIO(File.ReadAllBytes(SCENIC_TYPEFILE));

                int totalShapes = f.GetInt();
                _highestTypeIndex = f.GetInt();
                int totalShapesWithPhysics = f.GetInt();

                //This is where we load the BASIC information
                for (int i = 0; i < totalShapes; i++) {
                    int type_id = f.GetInt();
                    string source = f.GetString();
                    byte layer = f.GetByte();

                    s_objectTypes.Add(type_id, new ScenicType(type_id, source, layer));
                    s_StringToInt.Add(source, type_id);
                }

                //Now we load the PHYSICS information (yes quite expensive looping twice but much more backwards compatible
                for (int i = 0; i < totalShapesWithPhysics; i++) {
                    int type_id = f.GetInt();
                    int totalPhysics = f.GetInt();

                    for (int j = 0; j < totalPhysics; j++) {
                        int shapeType = f.GetByte();

                        float xPos = f.GetFloat();
                        float yPos = f.GetFloat();

                        switch ((PhysicsShapes)shapeType) {
                            case PhysicsShapes.Circle:
                                float r = f.GetFloat();
                                s_objectTypes[type_id].Physics.Add(new PhysicsCircle(new RectangleF(xPos, yPos, r, 0)));
                                break;
                            case PhysicsShapes.Rectangle:
                                float w = f.GetFloat();
                                float h = f.GetFloat();
                                s_objectTypes[type_id].Physics.Add(new PhysicsRectangle(new RectangleF(xPos, yPos, w, h)));
                                break;
                            default:
                                MessageBox.Show("Unknown shape found in file. Suspected corruption. Formatting C:");
                                break;
                        }
                    }
                }
            }

            //Scan for new objects
            foreach (string filename in Directory.GetFiles(Components.ObjectCacheControl.OBJECT_CACHE_FOLDER, "*.png", SearchOption.AllDirectories)) {
                if (!ImageCache.HasCached(filename)) {
                    _highestTypeIndex++;
                    s_objectTypes.Add(_highestTypeIndex, new ScenicType(_highestTypeIndex, filename, 0));
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
            //Count physics objects first...
            List<int> objectsWithPhysics = new List<int>();

            foreach (KeyValuePair<int, ScenicType> kvp in s_objectTypes) {
                if (kvp.Value.Physics.Count > 0) {
                    objectsWithPhysics.Add(kvp.Key);
                }
            }

            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectTypes.Count);
            f.AddInt(_highestTypeIndex);
            f.AddInt(objectsWithPhysics.Count); //total shapes with physics

            foreach (KeyValuePair<int, ScenicType> kvp in s_objectTypes) {
                f.AddInt(kvp.Key);
                f.AddString(kvp.Value.ImageName);
                f.AddByte(kvp.Value.layer);
            }

            //Now we load the PHYSICS information (yes quite expensive looping twice but much more backwards compatible
            foreach (int index in objectsWithPhysics) {
                f.AddInt(index);
                f.AddInt(s_objectTypes[index].Physics.Count);

                foreach (PhysicsShape ps in s_objectTypes[index].Physics) {
                    f.AddByte((byte)ps.myShape);

                    f.AddFloat(ps.aabb.Left);
                    f.AddFloat(ps.aabb.Top);

                    switch (ps.myShape) {
                        case PhysicsShapes.Circle:
                            f.AddFloat(ps.aabb.Width);
                            break;
                        case PhysicsShapes.Rectangle:
                            f.AddFloat(ps.aabb.Width);
                            f.AddFloat(ps.aabb.Height);
                            break;
                        default:
                            MessageBox.Show("Unknown shape found in file. Suspected corruption. Formatting C:");
                            break;
                    }
                }
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
