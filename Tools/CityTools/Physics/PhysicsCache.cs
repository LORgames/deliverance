using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;

namespace CityTools.Physics {
    public class PhysicsCache {

        public const string PHYSICS_CACHE_FILE = Program.CACHE + "physics.bin";

        public static List<PhysicsShape> shapes = new List<PhysicsShape>();

        private static int currentID = 0;

        public static void InitializeCache() {
            if (File.Exists(PHYSICS_CACHE_FILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(PHYSICS_CACHE_FILE));
                int totalShapes = f.GetInt();

                for (int i = 0; i < totalShapes; i++) {
                    int shapeType = f.GetInt();

                    if (shapeType == (int)PhysicsShapes.Rectangle) {
                        float r0 = f.GetFloat();
                        float r1 = f.GetFloat();
                        float r2 = f.GetFloat();
                        float r3 = f.GetFloat();

                        shapes.Add(new PhysicsRectangle(new System.Drawing.RectangleF(r0, r1, r2, r3), true));
                    } else if (shapeType == (int)PhysicsShapes.Circle) {
                        float r0 = f.GetFloat();
                        float r1 = f.GetFloat();
                        float r2 = f.GetFloat();

                        shapes.Add(new PhysicsCircle(new System.Drawing.RectangleF(r0, r1, r2, r2), true));
                    } else if (shapeType == (int)PhysicsShapes.Edge) {
                        float r0 = f.GetFloat();
                        float r1 = f.GetFloat();
                        float r2 = f.GetFloat();
                        float r3 = f.GetFloat();

                        shapes.Add(new PhysicsEdge(new System.Drawing.RectangleF(r0, r1, r2, r3), true));
                    }
                }

                f.Dispose();
            }
        }

        public static void AddShape(PhysicsShape shape) {
            currentID++;
            shape.physics_ID = currentID;
            shapes.Add(shape);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();
            f.AddInt(shapes.Count);

            foreach (PhysicsShape ps in shapes) {
                f.AddInt((int)ps.myShape);

                if (ps.myShape == PhysicsShapes.Rectangle) {
                    f.AddFloat(ps.aabb.Left);
                    f.AddFloat(ps.aabb.Top);
                    f.AddFloat(ps.aabb.Width);
                    f.AddFloat(ps.aabb.Height);
                } else if (ps.myShape == PhysicsShapes.Circle) {
                    f.AddFloat(ps.aabb.Left);
                    f.AddFloat(ps.aabb.Top);
                    f.AddFloat(ps.aabb.Width);
                } else if (ps.myShape == PhysicsShapes.Edge) {
                    f.AddFloat((ps as PhysicsEdge).p0.X);
                    f.AddFloat((ps as PhysicsEdge).p0.Y);
                    f.AddFloat((ps as PhysicsEdge).p1.X);
                    f.AddFloat((ps as PhysicsEdge).p1.Y);
                }
            }
            
            f.Encode(PHYSICS_CACHE_FILE);
            f.Dispose();
        }
    }
}
