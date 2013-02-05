using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CityTools.Stories;

namespace CityTools.Components {
    public partial class StoryCacheControl : UserControl {
        public StoryCacheControl() {
            InitializeComponent();
            UpdateWhenRequired();

            this.Dock = DockStyle.Fill;
        }

        public void UpdateWhenRequired() {
            flowLayoutPanel1.SuspendLayout();
            flowLayoutPanel1.Controls.Clear();
            flowLayoutPanel1.ResumeLayout();

            flowLayoutPanel1.SuspendLayout();

            for (int i = 0; i < StoryCache.stories.Count; i++) {
                CachedStory cs = new CachedStory(StoryCache.stories[i]);
                flowLayoutPanel1.Controls.Add(cs);
            }

            flowLayoutPanel1.ResumeLayout();
        }
    }
}
