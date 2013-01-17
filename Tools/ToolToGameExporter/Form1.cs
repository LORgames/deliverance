using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Ionic.Zip;
using System.IO;
using CityTools.Core;
using CityTools.Physics;

namespace ToolToGameExporter {
    public partial class Form1 : Form {
        public const float PHYSICS_SCALE = 10.0f;

        public Form1() {
            InitializeComponent();
        }

        private void tool_btn_Click(object sender, EventArgs e) {
            folderBrowserDialog1.ShowDialog();
            tool_loc_TB.Text = folderBrowserDialog1.SelectedPath;
        }

        private void game_btn_Click(object sender, EventArgs e) {
            folderBrowserDialog1.ShowDialog();
            game_loc_TB.Text = folderBrowserDialog1.SelectedPath;
        }

        private void convert_btn_Click(object sender, EventArgs e) {
            if (!File.Exists(GetGameLibZip())) {
                MessageBox.Show("The game content library does not exist. Did you select the correct folder?"); return;
            }

            if (!File.Exists(GetToolMap())) {
                MessageBox.Show("Cannot find map file in tool!"); return;
            }

            if (!File.Exists(GetScenicStore()) || !File.Exists(GetScenicTypes())) {
                MessageBox.Show("Cannot find the object layer!"); return;
            }

            if (!File.Exists(GetNodeStore())) {
                MessageBox.Show("Cannot find the node information!"); return;
            }

            ZipFile zip = new ZipFile(GetGameLibZip());

            //TILE CONVERSTION
            try { zip.RemoveEntry("0.map"); } catch { }
            zip.AddEntry("0.map", File.ReadAllBytes(GetToolMap()));

            //OBJECT CONVERSION
            try { zip.RemoveEntry("1.map"); } catch { }
            zip.AddEntry("1.map", File.ReadAllBytes(GetScenicStore()));

            try { zip.RemoveEntry("1.cache"); } catch { }
            OptimizeAndAddObjectLayer(zip);

            //NODE CONVERSION
            try { zip.RemoveEntry("2.map"); } catch { }
            ConvertNodeFormat(zip);

            //SAVE IT OUT
            while (true) {
                try {
                    zip.Save();
                    MessageBox.Show("Saved successfully!");
                    break;
                } catch {
                    MessageBox.Show("Please close the zip and then click OK");
                }
            }
        }

        private byte[] OptimizeAndAddObjectLayer(ZipFile zp) {
            ClearOutOldObjects(zp);

            BinaryIO f = new BinaryIO(File.ReadAllBytes(GetScenicTypes()));
            BinaryIO o = new BinaryIO();

            int totalShapes = f.GetInt();
            f.GetInt(); //Just need to clear this value :)
            int totalPhysicsShapes = f.GetInt();

            o.AddInt(totalShapes);
            o.AddInt(totalPhysicsShapes);

            Dictionary<int, string> typeID_to_filename = new Dictionary<int, string>();

            for (int i = 0; i < totalShapes; i++) {
                int type_id = f.GetInt();
                string source = f.GetString();
                byte layer = f.GetByte();

                zp.AddEntry("obj/" + type_id + ".png", File.ReadAllBytes(tool_loc_TB.Text + source));

                typeID_to_filename.Add(type_id, source);

                o.AddInt(type_id); //Type ID
                o.AddByte(layer);
            }

            for (int i = 0; i < totalPhysicsShapes; i++) {
                int typeID = f.GetInt();

                o.AddInt(typeID);

                int totalPhysics = f.GetInt();
                o.AddInt(totalPhysics);

                Image im = Image.FromFile(tool_loc_TB.Text + typeID_to_filename[typeID]);

                for (int j = 0; j < totalPhysics; j++) {
                    byte shapeType = f.GetByte();

                    o.AddByte(shapeType);

                    //This needs to be converted to the center rather than the extents.
                    float xPos = f.GetFloat(); //xPos
                    float yPos = f.GetFloat(); //yPos

                    float wDim = f.GetFloat();
                    float hDim = wDim;

                    if((PhysicsShapes)shapeType == PhysicsShapes.Rectangle) {
                        hDim = f.GetFloat();
                    }

                    xPos += (wDim - im.Width) / 2;
                    yPos += (hDim - im.Height) / 2;

                    o.AddFloat(xPos / PHYSICS_SCALE);
                    o.AddFloat(yPos / PHYSICS_SCALE);
                    o.AddFloat(wDim / PHYSICS_SCALE);
                    o.AddFloat(hDim / PHYSICS_SCALE);
                }

                im.Dispose();
            }

            f.Dispose();

            zp.AddEntry("1.cache", o.EncodedBytes());

            return null;
        }

        private void ClearOutOldObjects(ZipFile zp) {
            string[] files = new string[zp.EntryFileNames.Count];
            zp.EntryFileNames.CopyTo(files, 0);

            foreach (string entry in files) {
                if (entry.Substring(0, 4) == "obj/" && entry.Length > 6) {
                    zp.RemoveEntry(entry);
                }
            }
        }

        private void ConvertNodeFormat(ZipFile zp) {
            Dictionary<int, ToolNode> t_nodes = new Dictionary<int, ToolNode>();
            List<GameNode> g_nodes = new List<GameNode>();

            //Load All Nodes
            BinaryIO b = new BinaryIO(File.ReadAllBytes(GetNodeStore()));

            int totalNodes = b.GetInt();

            for (int i = 0; i < totalNodes; i++) {
                ToolNode n = new ToolNode();

                n.type = (byte)b.GetInt();
                n.nodeId = b.GetInt();
                n.xPos = b.GetFloat();
                n.yPos = b.GetFloat();

                n.children = new List<int>();

                int totalChildren = b.GetByte();

                System.Diagnostics.Debug.WriteLine(n.nodeId + " (" + totalChildren + ")");

                for (int j = 0; j < totalChildren; j++) {
                    n.children.Add(b.GetInt());
                    System.Diagnostics.Debug.WriteLine("\t" + n.nodeId + " => " + n.children[n.children.Count - 1]);
                }

                t_nodes.Add(n.nodeId, n);
            }

            //Calculate game id's
            List<int> nodeIds = t_nodes.Keys.ToList();
            nodeIds.Sort();

            int nextGameID = 0;

            for(int i = 0; i < nodeIds.Count; i++) {
                ToolNode t = t_nodes[nodeIds[i]];
                t.gameID = nextGameID;
                t_nodes[nodeIds[i]] = t;

                GameNode g = new GameNode();
                g.xPos = t.xPos;
                g.yPos = t.yPos;
                g.children = new List<int>();

                g_nodes.Add(g);

                nextGameID++;
            }

            //Update children in game nodes
            foreach (KeyValuePair<int, ToolNode> kvp in t_nodes) {
                foreach (int child in kvp.Value.children) {
                    g_nodes[kvp.Value.gameID].children.Add(t_nodes[child].gameID);
                }
            }

            //Output them to a new file
            BinaryIO o = new BinaryIO();
            o.AddInt(g_nodes.Count);

            for(int i = 0; i < g_nodes.Count; i++) {
                o.AddFloat(g_nodes[i].xPos);
                o.AddFloat(g_nodes[i].yPos);
                o.AddByte((byte)g_nodes[i].children.Count);
                for(int j = 0; j < g_nodes[i].children.Count; j++) {
                    o.AddInt(g_nodes[i].children[j]);
                }
            }

            zp.AddEntry("2.map", o.EncodedBytes());

            b.Dispose();
            o.Dispose();
        }

        //Game files
        private string GetGameLibZip() { return game_loc_TB.Text + "//lib//_embeds//default.zip"; }

        //Tool folders
        private string GetToolCacheLoc() { return tool_loc_TB.Text + "//cache//"; }
        private string GetObjCacheLoc() { return tool_loc_TB.Text + "//objcache//"; }

        //Tool files
        private string GetToolMap() { return GetToolCacheLoc() + "map.db"; }
        private string GetScenicStore() { return GetToolCacheLoc() + "scenic_store.bin"; }
        private string GetScenicTypes() { return GetToolCacheLoc() + "scenic_types.bin"; }
        private string GetNodeStore() { return GetToolCacheLoc() + "node_data.bin"; }
    }

    public struct ToolNode {
        public int nodeId;
        public byte type;
        public float xPos;
        public float yPos;
        public List<int> children;
        public int gameID;
    }

    public struct GameNode {
        public float xPos;
        public float yPos;
        public List<int> children;
    }
}
