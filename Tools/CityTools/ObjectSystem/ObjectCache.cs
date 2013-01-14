﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;

namespace CityTools.ObjectSystem {
    public class ObjectCache {

        public const string SCENIC_DATABASE = Program.CACHE+"/scenic/";
        public const string SCENIC_USERFILE = "scenic.bin";

        public static List<ScenicObject> s_objects = new List<ScenicObject>();

        public static void InitializeCache() {
            if (!Directory.Exists(SCENIC_DATABASE)) {
                Directory.CreateDirectory(SCENIC_DATABASE);
            }

            string[] files = Directory.GetFiles(SCENIC_DATABASE);

            foreach (string file in files) {
                if (File.Exists(file)) {
                    BinaryIO f = new BinaryIO(File.ReadAllBytes(file));
                    int totalShapes = f.GetInt();

                    for (int i = 0; i < totalShapes; i++) {
                        string source = f.GetString();
                        float locationX = f.GetFloat();
                        float locationY = f.GetFloat();
                        int rotation = f.GetInt();

                        s_objects.Add(new ScenicObject(source, new System.Drawing.PointF(locationX, locationY), rotation));
                    }
                }
            }
        }

        public static void AddShape(ScenicObject shape) {
            s_objects.Add(shape);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objects.Count);

            foreach (ScenicObject ps in s_objects) {
                f.AddString(ps.source);
                f.AddFloat(ps.baseBody.Position.X);
                f.AddFloat(ps.baseBody.Position.Y);
                f.AddInt(ps.angle);
            }

            f.Encode(SCENIC_DATABASE + SCENIC_USERFILE);
        }
    }
}
