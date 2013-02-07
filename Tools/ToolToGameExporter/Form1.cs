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

        Dictionary<int, int> remappedKeysForPlaces = new Dictionary<int, int>();  // <old, new>
        Dictionary<int, int> remappedKeysForPickup = new Dictionary<int, int>(); // <old, new>
        Dictionary<int, int> remappedKeysForDropoff = new Dictionary<int, int>(); // <old, new>

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
            ProcessMap(zip);

            //OBJECT CONVERSION
            try { zip.RemoveEntry("1.map"); } catch { }
            try { zip.RemoveEntry("1.cache"); } catch { }
            OptimizeAndAddObjectLayer(zip);

            //NODE CONVERSION
            try { zip.RemoveEntry("2.map"); } catch { }
            ConvertNodeFormat(zip);

            //PLACES CONVERSION
            try { zip.RemoveEntry("3.map"); } catch { }
            try { zip.RemoveEntry("3.cache"); } catch { }
            OptimizeAndAddPlaces(zip);

            try { zip.RemoveEntry("story.bin"); } catch { }
            OptimizeAndAddStories(zip);

            try { zip.RemoveEntry("WorldPhysics.bin"); } catch { }
            zip.AddEntry("WorldPhysics.bin", File.ReadAllBytes(GetToolCacheLoc() + "physics.bin"));

            try { zip.RemoveEntry("Resources.csv"); } catch { }
            try { zip.RemoveEntry("Characters.csv"); } catch { }
            try { zip.RemoveEntry("Upgrades.csv"); } catch { }

            zip.AddEntry("Resources.csv", File.ReadAllBytes(GetToolCacheLoc() + "Resources.csv"));
            zip.AddEntry("Characters.csv", File.ReadAllBytes(GetToolCacheLoc() + "People.csv"));
            zip.AddEntry("Upgrades.csv", File.ReadAllBytes(GetToolCacheLoc() + "Upgrades.csv"));

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

        private void ProcessMap(ZipFile zip) {
            zip.AddEntry("0.map", File.ReadAllBytes(GetToolMap()));

            //Clean out the old tiles
            string[] files = new string[zip.EntryFileNames.Count];
            zip.EntryFileNames.CopyTo(files, 0);

            foreach (string entry in files) {
                if (entry.Length > 9 && entry.Substring(0, 6) == "Tiles/") {
                    zip.RemoveEntry(entry);
                }
            }

            // Load the map from database
            BinaryIO mapFile = new BinaryIO(File.ReadAllBytes(GetToolMap()));

            int lmSizeX = mapFile.GetInt();
            int lmSizeY = mapFile.GetInt();

            Dictionary<byte, Boolean> loadedTiles = new Dictionary<byte, bool>();

            for (int i = 0; i < lmSizeX; i++) {
                for (int j = 0; j < lmSizeY; j++) {
                    byte tileID = mapFile.GetByte();

                    if (!loadedTiles.ContainsKey(tileID)) {
                        loadedTiles.Add(tileID, true);
                        zip.AddEntry("Tiles/" + tileID.ToString() + ".png", File.ReadAllBytes("../Tiles/" + tileID.ToString() + ".png"));
                    }
                }
            }

            mapFile.Dispose();
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
            Dictionary<int, int> remappedKeys = new Dictionary<int, int>();

            int previousKey = 0;

            for (int i = 0; i < totalShapes; i++) {
                int type_id = f.GetInt();
                string source = f.GetString();
                byte layer = f.GetByte();

                remappedKeys[type_id] = previousKey;

                zp.AddEntry("obj/" + previousKey + ".png", File.ReadAllBytes(tool_loc_TB.Text + source));

                typeID_to_filename.Add(type_id, source);

                o.AddByte(layer);

                previousKey++;
            }

            for (int i = 0; i < totalPhysicsShapes; i++) {
                int typeID = f.GetInt();

                o.AddInt(remappedKeys[typeID]);

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
                    } else if ((PhysicsShapes)shapeType == PhysicsShapes.Edge) {
                        hDim = f.GetFloat();
                    }


                    if ((PhysicsShapes)shapeType != PhysicsShapes.Edge) {
                        xPos += (wDim - im.Width) / 2;
                        yPos += (hDim - im.Height) / 2;
                        wDim /= 2; // Game uses radial w and h
                        hDim /= 2;
                    } else {
                        xPos -= im.Width / 2;
                        yPos -= im.Height / 2;
                        wDim -= im.Width / 2;
                        hDim -= im.Height / 2;
                    }

                    o.AddFloat(xPos / PHYSICS_SCALE);
                    o.AddFloat(yPos / PHYSICS_SCALE);
                    o.AddFloat(wDim / PHYSICS_SCALE);
                    o.AddFloat(hDim / PHYSICS_SCALE);
                }

                im.Dispose();
            }

            f.Dispose();

            zp.AddEntry("1.cache", o.EncodedBytes());

            o.Dispose();

            //Now the object store
            f = new BinaryIO(File.ReadAllBytes(GetScenicStore()));
            o = new BinaryIO();

            int totalObjects = f.GetInt();
            o.AddInt(totalObjects);

            for (int i = 0; i < totalObjects; i++) {
                int typeID = f.GetInt();
                float locationX = f.GetFloat();
                float locationY = f.GetFloat();
                int rotation = f.GetInt();

                o.AddInt(remappedKeys[typeID]);
                o.AddFloat(locationX);
                o.AddFloat(locationY);
                o.AddInt(rotation);
            }

            zp.AddEntry("1.map", o.EncodedBytes());

            f.Dispose();
            o.Dispose();

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

        private byte[] OptimizeAndAddPlaces(ZipFile zp) {
            ClearOutOldPlaces(zp);

            BinaryIO f = new BinaryIO(File.ReadAllBytes(GetPlacesTypes()));
            BinaryIO o = new BinaryIO();

            int totalShapes = f.GetInt();
            f.GetInt(); //Just need to clear this value :)

            o.AddInt(totalShapes);

            int previousKey = 0;

            short previousPICKUP = 0;
            short previousDROPAT = 0;

            for (int i = 0; i < totalShapes; i++) {
                int type_id = f.GetInt();
                string source = f.GetString();

                remappedKeysForPlaces[type_id] = previousKey;

                zp.AddEntry("Places/" + previousKey + ".png", File.ReadAllBytes(tool_loc_TB.Text + source));

                int startLoc = source.LastIndexOf('\\');
                int endLoc = source.LastIndexOf('.');

                string triggerName = source.Substring(startLoc+1, endLoc-startLoc-1);

                o.AddString(triggerName); //Trigger name

                previousKey++;
            }

            zp.AddEntry("3.cache", o.EncodedBytes());

            f.Dispose();
            o.Dispose();

            f = new BinaryIO(File.ReadAllBytes(GetPlacesStore()));
            o = new BinaryIO();

            // Load object instances from file
            totalShapes = f.GetInt();
            o.AddInt(totalShapes);

            for (int i = 0; i < totalShapes; i++) {
                int sourceID = f.GetInt();
                float locationX = f.GetFloat();
                float locationY = f.GetFloat();
                int rotation = f.GetInt();

                o.AddInt(remappedKeysForPlaces[sourceID]);
                o.AddFloat(locationX);
                o.AddFloat(locationY);
                o.AddInt(rotation);

                if (sourceID == 1 || sourceID == 2) {
                    //Need resources and npc values to be copied to the other thing now
                    o.AddInt(f.GetInt());
                    o.AddShort(f.GetShort());

                    //This needs to be remapped :)
                    short x = f.GetShort(); // The index

                    if (sourceID == 1) { // DROPAT?
                        remappedKeysForDropoff.Add(x, previousDROPAT);
                        previousDROPAT++;
                    } else {
                        remappedKeysForPickup.Add(x, previousPICKUP);
                        previousPICKUP++;
                    }
                }
            }

            zp.AddEntry("3.map", o.EncodedBytes());

            f.Dispose();
            o.Dispose();

            return null;
        }

        private void ClearOutOldPlaces(ZipFile zp) {
            string[] files = new string[zp.EntryFileNames.Count];
            zp.EntryFileNames.CopyTo(files, 0);

            foreach (string entry in files) {
                if (entry.Length > 8 && entry.Substring(0, 7) == "Places/") {
                    zp.RemoveEntry(entry);
                }
            }
        }

        private void OptimizeAndAddStories(ZipFile zp) {
            BinaryIO f = new BinaryIO(File.ReadAllBytes(GetStoryStore()));
            BinaryIO o = new BinaryIO();

            // Load story instances from file
            int totalStories = f.GetInt();
            o.AddInt(totalStories);

            for (int i = 0; i < totalStories; i++) {
                int startLocation = f.GetInt();
                int endLocation = f.GetInt();

                short npcImage1 = f.GetShort();
                short npcImage2 = f.GetShort();
                short npcImage3 = f.GetShort();
                short npcImage4 = f.GetShort();

                int repLevel = f.GetInt();
                int repGain = f.GetInt();
                int monGain = f.GetInt();
                string startText = f.GetString();
                string pickupText = f.GetString();
                string endText = f.GetString();
                byte numEnemies = f.GetByte();

                o.AddInt(remappedKeysForPickup[startLocation]);
                o.AddInt(remappedKeysForDropoff[endLocation]);
                o.AddShort(npcImage1);
                o.AddShort(npcImage2);
                o.AddShort(npcImage3);
                o.AddShort(npcImage4);
                o.AddInt(repLevel);
                o.AddInt(repGain);
                o.AddInt(monGain);
                o.AddString(startText);
                o.AddString(pickupText);
                o.AddString(endText);
                o.AddShort(numEnemies);
            }

            zp.AddEntry("story.bin", o.EncodedBytes());

            f.Dispose();
            o.Dispose();
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
        private string GetPlacesStore() { return GetToolCacheLoc() + "places_store.bin"; }
        private string GetPlacesTypes() { return GetToolCacheLoc() + "places_types.bin"; }
        private string GetStoryStore() { return GetToolCacheLoc() + "story_data.bin"; }
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
