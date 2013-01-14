using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;

namespace CityTools.Nodes {
    class NodeCache {

        public const string NODE_DATABASE = Program.CACHE + "/node/";
        public const string NODE_DATAFILE = NODE_DATABASE + "node_data.bin";

        public static Dictionary<short, Node> nodes = new Dictionary<short, Node>();
        public static List<List<short>> nodeLinks = new List<List<short>>();

        public static void InitializeCache() {
            if (!Directory.Exists(NODE_DATABASE)) {
                Directory.CreateDirectory(NODE_DATABASE);
            }

            if (File.Exists(NODE_DATAFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(NODE_DATAFILE));

                // Add Nodes
                int totalNodes = f.GetInt();

                for (int i = 0; i < totalNodes; i++) {
                    short index = f.GetShort();
                    float locationX = f.GetFloat();
                    float locationY = f.GetFloat();

                    nodes.Add(index, new Node(locationX, locationY));
                    nodes[index].index = index;
                    Node.CURRENT_INDEX = (short)(index + 1); // Apparently short + short = int...
                }

                // Add Node Links
                // Total link lists
                int totalLinks = f.GetInt();
                for (int i = 0; i < totalLinks; i++) {

                    // Create a list for the node indices
                    nodeLinks.Add(new List<short>());

                    // Total linked nodes in the list
                    int totalNodeLinks = f.GetInt();
                    for (int j = 0; j < totalNodeLinks; j++) {

                        // Add that motherfucker to the list.
                        nodeLinks[nodeLinks.Count - 1].Add(f.GetShort());
                    }
                }
            }
        }

        public static void AddNode(Node node) {
            nodes.Add(node.index, node);
        }

        public static void AddNodeLink(List<short> nodeLink) {
            nodeLinks.Add(nodeLink);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();

            // Store number of nodes
            f.AddInt(nodes.Count);

            // Store each nodes index and position
            foreach (KeyValuePair<short, Node> pair in nodes) {
                f.AddShort(pair.Value.index);
                f.AddFloat(pair.Value.baseBody.Position.X);
                f.AddFloat(pair.Value.baseBody.Position.Y);
            }

            // Store number of node link lists
            f.AddInt(nodeLinks.Count);
            for (int i = 0; i < nodeLinks.Count; i++) {
                
                // Check if link is valid
                bool storeLink = true;
                for (int j = 0; j < nodeLinks[i].Count; j++) {
                    if (!nodes.ContainsKey(nodeLinks[i][j])) {
                        storeLink = false;
                    }
                }

                // Store link if it's valid
                if (storeLink) {
                    // Store number of indices in the node link list
                    f.AddInt(nodeLinks[i].Count);
                    for (int j = 0; j < nodeLinks[i].Count; j++) {

                        // Store indices
                        f.AddShort(nodeLinks[i][j]);
                    }
                }
            }

            f.Encode(NODE_DATAFILE);
        }
    }
}
