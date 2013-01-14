using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;

namespace CityTools.Nodes {
    class NodeCache {

        public const string NODE_DATABASE = Program.CACHE + "/node/";
        public const string NODE_USERFILE = ".bin";

        public static List<Node> nodes = new List<Node>();
        public static List<List<int>> nodeLinks = new List<List<int>>();

        public static void InitializeCache() {
            if (!Directory.Exists(NODE_DATABASE)) {
                Directory.CreateDirectory(NODE_DATABASE);
            }

            string[] files = Directory.GetFiles(NODE_DATABASE);

            foreach (string file in files) {
                if (File.Exists(file)) {
                    BinaryIO f = new BinaryIO(File.ReadAllBytes(file));
                    int totalNodes = f.GetInt();

                    for (int i = 0; i < totalNodes; i++) {
                        float locationX = f.GetFloat();
                        float locationY = f.GetFloat();

                        nodes.Add(new Node(locationX, locationY));
                    }
                }
            }
        }

        public static void AddNode(Node node) {
            nodes.Add(node);
        }

        public static void AddNodeLink(List<int> nodeLink) {
            nodeLinks.Add(nodeLink);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();
            f.AddInt(nodes.Count);

            foreach (Node node in nodes) {
                f.AddFloat(node.baseBody.Position.X);
                f.AddFloat(node.baseBody.Position.Y);
            }

            f.Encode(NODE_DATABASE + Environment.UserName + NODE_USERFILE);
        }
    }
}
