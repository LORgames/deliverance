using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;

namespace CityTools.Nodes {
    class NodeCache {

        public const string NODE_DATABASE = Program.CACHE;
        public const string NODE_DATAFILE = NODE_DATABASE + "node_data.bin";

        public static Dictionary<int, Node> nodes = new Dictionary<int,Node>();

        public static void InitializeCache() {
            if (!Directory.Exists(NODE_DATABASE)) {
                Directory.CreateDirectory(NODE_DATABASE);
            }

            if (File.Exists(NODE_DATAFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(NODE_DATAFILE));

                // Add Nodes
                int totalNodes = f.GetInt();

                for (int i = 0; i < totalNodes; i++) {
                    int type = f.GetInt();
                    int index = f.GetInt();
                    float locationX = f.GetFloat();
                    float locationY = f.GetFloat();

                    nodes.Add(index, new Node(locationX, locationY, type));
                    nodes[index].index = index;

                    int numChildren = f.GetByte();
                    for (int j = 0; j < numChildren; j++) {
                        nodes[index].children.Add(f.GetInt());
                    }

                    if (index >= Node.CURRENT_INDEX) {
                        Node.CURRENT_INDEX = index + 1;
                    }
                }
            }
        }

        public static void AddNode(Node node) {
            nodes.Add(node.index, node);
        }

        public static void AddNodeLink(Node from, Node to) {
            nodes[from.index].children.Add(to.index);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();

            // Store number of nodes
            f.AddInt(nodes.Count);

            // Store each nodes index and position
            foreach (KeyValuePair<int, Node> pair in nodes) {
                f.AddInt(pair.Value.type);
                f.AddInt(pair.Value.index);
                f.AddFloat(pair.Value.baseBody.Position.X);
                f.AddFloat(pair.Value.baseBody.Position.Y);
                f.AddByte((byte)pair.Value.children.Count);
                for (int i = 0; i < pair.Value.children.Count; i++) {
                    f.AddInt(pair.Value.children[i]);
                }
            }

            f.Encode(NODE_DATAFILE);
        }
    }
}
