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

            ZipFile zip = new ZipFile(GetGameLibZip());
            
            zip.RemoveEntry("mapcache\\maptest.map");
            zip.AddEntry("mapcache\\maptest.map", File.ReadAllBytes(GetToolMap()));

            zip.Save();
        }

        private string GetGameLibZip() {
            return game_loc_TB.Text + "//lib//_embeds//default.zip";
        }

        private string GetToolCacheLoc() {
            return tool_loc_TB.Text + "//cache//";
        }

        private string GetToolMap() {
            return GetToolCacheLoc() + "map.db";
        }
    }
}
