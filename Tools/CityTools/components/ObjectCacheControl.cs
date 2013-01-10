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

        public bool isCacheFolder = true;
        public string folder;

        public ObjectCacheControl(string cacheFolder, bool addObjectCache = true) {
            InitializeComponent();

            this.Dock = DockStyle.Fill;
            this.isCacheFolder = addObjectCache;

            if (addObjectCache) {
                this.folder = OBJECT_CACHE_FOLDER + cacheFolder;
            } else {
                this.folder = cacheFolder;
            }

            Activate();
        }

        public void Activate(string folder_b = "") {
            if (folder_b != "") {
                if (this.isCacheFolder) {
                    this.folder = OBJECT_CACHE_FOLDER + folder_b;
                } else {
                    this.folder = folder_b;
                }
            }

            if (!Directory.Exists(folder))
                Directory.CreateDirectory(folder);

            string[] files = Directory.GetFiles(folder, "*.png");

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
