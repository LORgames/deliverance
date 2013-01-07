using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace CityTools.Physics {
    public class PhysicsCache {

        public const string PHYSICS_CACHE_FILE = "mapcache/physics.db";

        public PhysicsChunk[,] chunks;
        public List<PhysicsShape> shapes;

        private static int currentID = 0;

        public static void InitializeCache() {
            if (File.Exists(PHYSICS_CACHE_FILE)) {
                File.Create(PHYSICS_CACHE_FILE);
            }

            BinaryReader f = new BinaryReader(PHYSICS_CACHE_FILE);
            //File.read
        }

        public static void AddShape(PhysicsShape shape) {
            //TODO: Implement this (AddShape);
        }

    }
}
