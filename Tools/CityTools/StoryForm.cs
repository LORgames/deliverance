using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CityTools.Stories;

namespace CityTools {
    public partial class StoryForm : Form {
        public static StoryForm instance;

        public StoryForm() {
            instance = this;
            InitializeComponent();
        }

        public bool InStartLocation() {
            return this.ActiveControl == txtStartLocation;
        }

        public void SetStartLocation(int startLocationIndex) {
            txtStartLocation.Text = startLocationIndex.ToString();
        }

        public bool InEndLocation() {
            return this.ActiveControl == txtEndLocation;
        }

        public void SetEndLocation(int endLocationIndex) {
            txtEndLocation.Text = endLocationIndex.ToString();
        }

        private void btnSave_Click(object sender, EventArgs e) {
            Story temp = new Story(int.Parse(txtStartLocation.Text), int.Parse(txtEndLocation.Text), cmbNPCImage.Text,
                int.Parse(txtRepLevel.Text), (byte)int.Parse(txtResourceType.Text), int.Parse(txtQuantity.Text),
                txtStartText.Text, txtEndText.Text);

            StoryCache.AddStory(temp);
        }
    }
}
