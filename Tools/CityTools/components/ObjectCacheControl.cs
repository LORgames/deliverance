using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace CityTools.Components {
    public partial class ObjectCacheControl : UserControl {
        public const string OBJECT_CACHE_FOLDER = ".\\objcache\\";
        public string folder;

        public ObjectCacheControl(string cacheFolder) {
            InitializeComponent();

            this.Dock = DockStyle.Fill;
            this.folder = cacheFolder;

            Activate();
        }

        public void Activate(string folder_b = "") {
            if (folder_b != "")
                this.folder = folder_b;

            if (!Directory.Exists(OBJECT_CACHE_FOLDER + folder))
                Directory.CreateDirectory(OBJECT_CACHE_FOLDER + folder);

            string[] files = Directory.GetFiles(OBJECT_CACHE_FOLDER + folder, "*.png");

            if (files.Length != flowLayoutPanel1.Controls.Count) {
                Deactivate();

                flowLayoutPanel1.SuspendLayout();

                foreach (string s in files) {
                    CachedObject co = new CachedObject(s);
                    flowLayoutPanel1.Controls.Add(co);
                }

                flowLayoutPanel1.ResumeLayout();
            }
        }

        public void Deactivate() {
            flowLayoutPanel1.SuspendLayout();
            flowLayoutPanel1.Controls.Clear();
            flowLayoutPanel1.ResumeLayout();
        }
    }
}
