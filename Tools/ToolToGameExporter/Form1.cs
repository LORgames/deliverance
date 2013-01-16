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

namespace ToolToGameExporter {
    public partial class Form1 : Form {
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

            ZipFile zip = new ZipFile(GetGameLibZip());

            try { zip.RemoveEntry("0.map"); } catch { }
            zip.AddEntry("0.map", File.ReadAllBytes(GetToolMap()));

            try { zip.RemoveEntry("1.map"); } catch { }
            zip.AddEntry("1.map", File.ReadAllBytes(GetScenicStore()));

            try { zip.RemoveEntry("1.cache"); } catch { }
            //zip.AddEntry("1.cache", OptimizeAndAddObjectLayer(zip));

            OptimizeAndAddObjectLayer(zip);

            while (true) {
                try {
                    zip.Save();
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

            o.AddInt(totalShapes);

            for (int i = 0; i < totalShapes; i++) {
                int type_id = f.GetInt();
                string source = f.GetString();

                zp.AddEntry("obj/" + type_id + ".png", File.ReadAllBytes(tool_loc_TB.Text + source));

                o.AddInt(type_id); //Type ID
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

        //Game files
        private string GetGameLibZip() { return game_loc_TB.Text + "//lib//_embeds//default.zip"; }

        //Tool folders
        private string GetToolCacheLoc() { return tool_loc_TB.Text + "//cache//"; }
        private string GetObjCacheLoc() { return tool_loc_TB.Text + "//objcache//"; }

        //Tool files
        private string GetToolMap() { return GetToolCacheLoc() + "map.db"; }
        private string GetScenicStore() { return GetToolCacheLoc() + "scenic_store.bin"; }
        private string GetScenicTypes() { return GetToolCacheLoc() + "scenic_types.bin"; }
    }
}
