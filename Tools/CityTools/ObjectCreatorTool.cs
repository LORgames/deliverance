using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CityTools {
    public partial class ObjectCreatorTool : Form {
        public ObjectCreatorTool () {
            InitializeComponent();
        }

        private void pictureBox1_Paint(object sender, PaintEventArgs e) {
            e.Graphics.Clear(Color.White);
        }
    }
}
