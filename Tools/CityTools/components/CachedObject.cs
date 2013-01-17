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
        internal string img_addr = "";

        public CachedObject(string image, string labelT = "") {
            InitializeComponent();

            img_addr = image;
            label.Text = labelT;

            pictureBox1.Load(image);
        }

        internal void Unload() {
            pictureBox1.Dispose();
        }

        private void pictureBox1_MouseClick(object sender, MouseEventArgs e) {
            MainWindow.instance.DrawWithObject(img_addr);
        }
    }
}
