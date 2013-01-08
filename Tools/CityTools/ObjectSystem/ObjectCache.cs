using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace CityTools.ObjectSystem {
    public class ObjectCache {

        public const string SCENIC_DATABASE = "mapcache/objects.db";

        public static List<ScenicObject> s_objects = new List<ScenicObject>();

        public static void InitializeCache() {
            if (File.Exists(SCENIC_DATABASE)) {
                File.Create(SCENIC_DATABASE);
            }

            BinaryIO f = new BinaryIO(File.ReadAllBytes(SCENIC_DATABASE));
            int totalShapes = f.GetInt();

            for (int i = 0; i < totalShapes; i++) {
                string source = f.GetString();
                float locationX = f.GetFloat();
                float locationY = f.GetFloat();
                float rotation = f.GetFloat();
            }
        }

        public static void AddShape(ScenicObject shape) {
            s_objects.Add(shape);
        }

        public static void SaveCache() {
            if (File.Exists(SCENIC_DATABASE)) {
                File.Create(SCENIC_DATABASE);
            }

            BinaryIO f = new BinaryIO();
            f.AddInt(s_objects.Count);

            foreach (ScenicObject ps in s_objects) {
                f.AddString(ps.source);
                f.AddFloat(ps.baseBody.Position.X);
                f.AddFloat(ps.baseBody.Position.Y);
                f.AddFloat(ps.baseBody.Angle);
            }
            
            f.Encode(SCENIC_DATABASE);
        }
    }
}
