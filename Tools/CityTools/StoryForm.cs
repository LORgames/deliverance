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
            if (txtStartLocation.Text != "" && txtEndLocation.Text != "" && cmbNPCImage1.SelectedIndex != -1
                && cmbNPCImage2.SelectedIndex != -1 && txtRepLevel.Text != "" && cmbResourceType.SelectedIndex != -1
                && txtQuantity.Text != "") {

                if (btnSave.Text == "Save") {
                
                    Story temp = new Story(int.Parse(txtStartLocation.Text), int.Parse(txtEndLocation.Text),
                        (short)cmbNPCImage1.SelectedIndex, (short)cmbNPCImage2.SelectedIndex,
                        int.Parse(txtRepLevel.Text), (byte)cmbResourceType.SelectedIndex, int.Parse(txtQuantity.Text),
                        txtStartText.Text, txtEndText.Text);

                    StoryCache.AddStory(temp);
                } else {
                    
                    StoryCache.stories[index].startLocation = int.Parse(txtStartLocation.Text);
                    StoryCache.stories[index].endLocation = int.Parse(txtEndLocation.Text);
                    StoryCache.stories[index].npcImage1 = (short)cmbNPCImage1.SelectedIndex;
                    StoryCache.stories[index].npcImage2 = (short)cmbNPCImage2.SelectedIndex;
                    StoryCache.stories[index].repLevel = int.Parse(txtRepLevel.Text);
                    StoryCache.stories[index].resType = (byte)cmbResourceType.SelectedIndex;
                    StoryCache.stories[index].quantity = int.Parse(txtQuantity.Text);
                    StoryCache.stories[index].startText = txtStartText.Text;
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
            cmbNPCImage1.SelectedIndex = -1;
            cmbNPCImage2.SelectedIndex = -1;
            txtRepLevel.Text = "";
            cmbResourceType.SelectedIndex = -1;
            cmbResourceType.Items.Clear();
            for (int i = 0; i < Places.PlacesObjectCache.resources.Count; i++) {
                cmbResourceType.Items.Add(Places.PlacesObjectCache.resources[i]);
            }
            txtQuantity.Text = "";
            txtStartText.Text = "";
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
            cmbNPCImage1.SelectedIndex = story.npcImage1;
            cmbNPCImage2.SelectedIndex = story.npcImage2;
            txtRepLevel.Text = story.repLevel.ToString();
            cmbResourceType.SelectedIndex = story.resType;
            txtQuantity.Text = story.quantity.ToString();
            txtStartText.Text = story.startText;
            txtEndText.Text = story.endText;

            btnSave.Text = "Edit";
        }
    }
}
