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


        public CachedObject(string image) {
            InitializeComponent();

            pictureBox1.Load(image);
        }

        internal void Unload() {
            pictureBox1.Dispose();
        }

        private void pictureBox1_MouseClick(object sender, MouseEventArgs e) {
            MainWindow.instance.DrawWithObject(pictureBox1.Image);
        }
    }
}
