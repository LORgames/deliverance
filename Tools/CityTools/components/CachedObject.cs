using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CityTools.Components {
    public partial class CachedObject : UserControl {
        private string img_addr = "";

        public CachedObject(string image) {
            InitializeComponent();

            img_addr = image;
            pictureBox1.Load(image);
        }

        internal void Unload() {
            pictureBox1.Dispose();
        }

        private void pictureBox1_MouseClick(object sender, MouseEventArgs e) {
            MainWindow.instance.DrawWithObject(img_addr);
            CityTools.ObjectSystem.ObjectDrawer.image_name = img_addr;
        }
    }
}
