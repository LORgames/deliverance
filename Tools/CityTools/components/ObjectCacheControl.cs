using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using CityTools.ObjectSystem;

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
			bool requiresReload = false;
		
            if (folder_b != "") {
                requiresReload = true;

                if (this.isCacheFolder) {
                    this.folder = OBJECT_CACHE_FOLDER + folder_b;
                } else {
                    this.folder = folder_b;
                }
            }

            if (!Directory.Exists(folder)) {
                MessageBox.Show(folder + " could not be found. An unexpected error has occurred!");
            }

            string[] files = Directory.GetFiles(folder, "*.png");

            if (files.Length != flowLayoutPanel1.Controls.Count || requiresReload) {
                Deactivate();

                flowLayoutPanel1.SuspendLayout();

                foreach (string s in files) {
                    CachedObject co;

                    if (isCacheFolder) {
                        ScenicType st = ScenicObjectCache.s_objectTypes[ScenicObjectCache.s_StringToInt[s]];
                        co = new CachedObject(s, (st.layer==1?"A":"B")+(st.Physics.Count>0?"P":""));
                    } else {
                        co = new CachedObject(s);
                    }

                    if (isCacheFolder) {
                        co.ContextMenuStrip = objCache_contextMenu;
                    }

                    flowLayoutPanel1.Controls.Add(co);
                }

                flowLayoutPanel1.ResumeLayout();
            } else if (folder_b == "" && isCacheFolder) {
                foreach (Control c in flowLayoutPanel1.Controls) {
                    if (c is CachedObject) {
                        ScenicType st = ScenicObjectCache.s_objectTypes[ScenicObjectCache.s_StringToInt[(c as CachedObject).img_addr]];
                        (c as CachedObject).label.Text = (st.layer == 1 ? "A" : "B") + (st.Physics.Count > 0 ? "P" : "");
                    }
                }
            }
        }

        public void Deactivate() {
            flowLayoutPanel1.SuspendLayout();
            flowLayoutPanel1.Controls.Clear();
            flowLayoutPanel1.ResumeLayout();
        }

        private void editObjectDetailsToolStripMenuItem_Click(object sender, EventArgs e) {
            ToolStripDropDownItem t = sender as ToolStripDropDownItem;
            if (t == null) return;

            ContextMenuStrip cm = t.Owner as ContextMenuStrip;
            if (cm == null) return;

            if (cm.SourceControl is CachedObject) {
                CachedObject co = cm.SourceControl as CachedObject;

                ObjectCreatorTool oct = new ObjectCreatorTool(ScenicObjectCache.s_StringToInt[co.img_addr]);
                oct.Show();
            }
        }

        private void requestedLayerChange(object sender, EventArgs e) {
            ToolStripDropDownItem t = sender as ToolStripDropDownItem;
            if (t == null) return;

            ContextMenuStrip cm = t.Owner as ContextMenuStrip;
            if (cm == null) return;

            if (cm.SourceControl is CachedObject) {
                CachedObject co = cm.SourceControl as CachedObject;

                ScenicObjectCache.s_objectTypes[ScenicObjectCache.s_StringToInt[co.img_addr]].layer = (byte)(t.Text == "Below Traffic" ? 0 : 1);
                
                ScenicType st = ScenicObjectCache.s_objectTypes[ScenicObjectCache.s_StringToInt[co.img_addr]];
                co.label.Text = (st.layer == 1 ? "A" : "B") + (st.Physics.Count > 0 ? "P" : "");
            }
        }
    }
}
