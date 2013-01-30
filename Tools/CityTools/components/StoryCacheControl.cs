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

            this.Dock = DockStyle.Fill;
        }

        private void StoryCacheControl_Paint(object sender, PaintEventArgs e) {
            flowLayoutPanel1.Controls.Clear();
            for (int i = 0; i < StoryCache.stories.Count; i++) {
                flowLayoutPanel1.Controls.Add(new CachedStory(StoryCache.stories[i]));
            }
        }
    }
}
