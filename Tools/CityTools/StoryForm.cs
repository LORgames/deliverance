using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CityTools.Stories;
using CityTools.Places;
using Box2CS;
using CityTools.Core;
using System.IO;

namespace CityTools {
    public partial class StoryForm : Form {
        private static List<PlacesObject> selectedObjects = new List<PlacesObject>();
        public static StoryForm instance;

        private int index = -1;

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
            if (txtStartLocation.Text != "" && txtEndLocation.Text != "" && cmbStartNPCImage1.SelectedIndex != -1
                && cmbStartNPCImage2.SelectedIndex != -1 && txtRepLevel.Text != "" && cmbResourceType.SelectedIndex != -1) {

                if (btnSave.Text == "Save") {
                
                    Story temp = new Story(int.Parse(txtStartLocation.Text), int.Parse(txtEndLocation.Text),
                        (short)cmbStartNPCImage1.SelectedIndex, (short)cmbStartNPCImage2.SelectedIndex, (short)cmbEndNPCImage1.SelectedIndex, (short)cmbEndNPCImage2.SelectedIndex,
                        int.Parse(txtRepLevel.Text), (byte)cmbResourceType.SelectedIndex, tbQuantity.Value,
                        txtStartText.Text, txtPickupText.Text, txtEndText.Text);

                    StoryCache.AddStory(temp);
                } else {
                    
                    StoryCache.stories[index].startLocation = int.Parse(txtStartLocation.Text);
                    StoryCache.stories[index].endLocation = int.Parse(txtEndLocation.Text);
                    StoryCache.stories[index].npcStartImage1 = (short)cmbStartNPCImage1.SelectedIndex;
                    StoryCache.stories[index].npcStartImage2 = (short)cmbStartNPCImage2.SelectedIndex;
                    StoryCache.stories[index].npcEndImage1 = (short)cmbEndNPCImage1.SelectedIndex;
                    StoryCache.stories[index].npcEndImage2 = (short)cmbEndNPCImage2.SelectedIndex;
                    StoryCache.stories[index].repLevel = int.Parse(txtRepLevel.Text);
                    StoryCache.stories[index].resType = (byte)cmbResourceType.SelectedIndex;
                    StoryCache.stories[index].quantity = tbQuantity.Value;
                    StoryCache.stories[index].startText = txtStartText.Text;
                    StoryCache.stories[index].pickupText = txtPickupText.Text;
                    StoryCache.stories[index].endText = txtEndText.Text;
                }

                MainWindow.instance.paintMode = PaintMode.Off;

                MainWindow.instance.story_storyPan.Controls[0].Invalidate();

                this.Hide();
            }
        }

        private void StoryForm_Shown(object sender, EventArgs e) {
            txtStartLocation.Text = "";
            txtEndLocation.Text = "";

            txtRepLevel.Text = "";
            cmbResourceType.SelectedIndex = -1;
            cmbResourceType.Items.Clear();

            cmbStartNPCImage1.SelectedIndex = -1;
            cmbStartNPCImage1.Items.Clear();
            cmbStartNPCImage2.SelectedIndex = -1;
            cmbStartNPCImage2.Items.Clear();

            cmbEndNPCImage1.SelectedIndex = -1;
            cmbEndNPCImage1.Items.Clear();
            cmbEndNPCImage2.SelectedIndex = -1;
            cmbEndNPCImage2.Items.Clear();
            
            for (int i = 0; i < Places.PlacesObjectCache.resources.Count; i++) {
                cmbResourceType.Items.Add(Places.PlacesObjectCache.resources[i]);
            }

            for (int i = 0; i < Places.PlacesObjectCache.people.Count; i++) {
                cmbStartNPCImage1.Items.Add(Places.PlacesObjectCache.people[i]);
                cmbEndNPCImage1.Items.Add(Places.PlacesObjectCache.people[i]);
            }

            tbQuantity.Value = 0;
            txtStartText.Text = "";
            txtPickupText.Text = "";
            txtEndText.Text = "";

            index = -1;

            btnSave.Text = "Save";
        }

        private void StoryForm_FormClosing(object sender, FormClosingEventArgs e) {
            e.Cancel = true;
            this.Hide();
        }

        internal void MouseClick(MouseEventArgs e) {
            foreach (PlacesObject s in selectedObjects) {
                s.selected = false;
            }

            selectedObjects.Clear();

            PointF p0a = new PointF(Math.Min(e.X, e.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Min(e.Y, e.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);
            PointF p1a = new PointF(Math.Max(e.X, e.X) / Camera.ZoomLevel + Camera.ViewArea.Left, Math.Max(e.Y, e.Y) / Camera.ZoomLevel + Camera.ViewArea.Top);

            AABB aabb = new AABB(new Vec2(p0a.X, p0a.Y), new Vec2(p1a.X, p1a.Y));

            Box2D.B2System.world.QueryAABB(new Box2CS.World.QueryCallbackDelegate(StoryForm.QCBD), aabb);

            int highestIndex = -1; // Highest index 

            // Locate the highest index
            for (int i = 0; i < selectedObjects.Count; i++) {

                // If current objects index is higher, store it as the highest index
                if (selectedObjects[i].index > highestIndex) {
                    highestIndex = selectedObjects[i].index;
                }
            }

            // Remove all other objects
            for (int i = 0; i < selectedObjects.Count; i++) {
                if (selectedObjects[i].index != highestIndex) {
                    selectedObjects.RemoveAt(i);
                    i--;
                }
            }

            if (this.ActiveControl == this.txtStartLocation) {
                txtStartLocation.Text = selectedObjects[0].index.ToString();
                selectedObjects.Clear();
            } else if (this.ActiveControl == this.txtEndLocation) {
                txtEndLocation.Text = selectedObjects[0].index.ToString();
                selectedObjects.Clear();
            }
        }

        public static bool QCBD(Fixture fix) {
            if (fix.UserData is PlacesObject) {
                selectedObjects.Add(fix.UserData as PlacesObject);
            }

            return true;
        }

        internal void Fill(Story story) {
            index = StoryCache.stories.IndexOf(story);

            txtStartLocation.Text = story.startLocation.ToString();
            txtEndLocation.Text = story.endLocation.ToString();

            cmbStartNPCImage1.SelectedIndex = story.npcStartImage1;
            cmbStartNPCImage2.SelectedIndex = story.npcStartImage2;

            cmbEndNPCImage1.SelectedIndex = story.npcEndImage1;
            cmbEndNPCImage2.SelectedIndex = story.npcEndImage2;

            txtRepLevel.Text = story.repLevel.ToString();
            cmbResourceType.SelectedIndex = story.resType;
            tbQuantity.Value = story.quantity;
            txtStartText.Text = story.startText;
            txtPickupText.Text = story.pickupText;
            txtEndText.Text = story.endText;

            btnSave.Text = "Edit";
        }

        private void cmbNPCImage_SelectedIndexChanged(object sender, EventArgs e) {
            ComboBox cmb1 = cmbStartNPCImage1;
            ComboBox cmb2 = cmbStartNPCImage2;

            if (sender == cmbEndNPCImage1) {
                cmb1 = cmbEndNPCImage1;
                cmb2 = cmbEndNPCImage2;
            }

            cmb2.Items.Clear();

            if (cmb1.SelectedIndex > -1) {
                string[] files = Directory.GetFiles("People", cmb1.SelectedIndex + "_*.png");
                for (int i = 0; i < files.Length; i++) {
                    cmb2.Items.Add(i.ToString());
                }

                cmb2.SelectedIndex = 0;
            }
        }

        private void UpdateNPCPicture(object sender, EventArgs e) {
            if (sender == cmbStartNPCImage2) {
                pbStartNPC.LoadAsync("People\\" + cmbStartNPCImage1.SelectedIndex + "_" + cmbStartNPCImage2.SelectedIndex + ".png");
            } else {
                pbEndNPC.LoadAsync("People\\" + cmbEndNPCImage1.SelectedIndex + "_" + cmbEndNPCImage2.SelectedIndex + ".png");
            }
        }

        private void cmbResourceType_SelectedIndexChanged(object sender, EventArgs e) {
            if (cmbResourceType.SelectedIndex > -1) {
                tbQuantity.Minimum = PlacesObjectCache.resources_min[cmbResourceType.SelectedIndex];
                tbQuantity.Maximum = PlacesObjectCache.resources_max[cmbResourceType.SelectedIndex];

                tbQuantity_ValueChanged(null, null);
            }

        }

        private void tbQuantity_ValueChanged(object sender, EventArgs e) {
            if (cmbResourceType.SelectedIndex < 0) {
                resource_info.Text = "<V Select Both first.";
                return;
            }

            resource_info.Text = tbQuantity.Value + "x = $" + (tbQuantity.Value * PlacesObjectCache.resources_money[cmbResourceType.SelectedIndex]) + " & " + (tbQuantity.Value * PlacesObjectCache.resources_rep[cmbResourceType.SelectedIndex]) + " Reputation";
        }
    }
}
