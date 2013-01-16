using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CityTools.Core;
using CityTools.ObjectSystem;

namespace CityTools {
    public partial class ObjectCreatorTool : Form {
        Image precache;

        public ObjectCreatorTool (int objectID) {
            InitializeComponent();

            precache = ImageCache.RequestImage(ScenicObjectCache.s_objectTypes[objectID].ImageName);
        }

        private void pictureBox1_Paint(object sender, PaintEventArgs e) {
            e.Graphics.Clear(Color.White);
        }
    }
}
