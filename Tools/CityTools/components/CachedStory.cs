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
    internal partial class CachedStory : UserControl {
        Story story;

        public CachedStory(Story story) {
            InitializeComponent();

            this.story = story;

            this.lblStartLocation.Text = "Start Location: " + story.startLocation.ToString();
            this.lblEndLocation.Text = "End Location: " + story.endLocation.ToString();
            this.lblNPCImage.Text = "Start NPC Image: " + story.npcStartImage1.ToString() + "_" + story.npcStartImage2.ToString();
            this.lblNPCImage.Text = "End NPC Image: " + story.npcEndImage1.ToString() + "_" + story.npcEndImage2.ToString();
            this.lblRepLevel.Text = "Rep Level: " + story.repLevel.ToString();
            this.lblResType.Text = "RepGain: " + story.repGain.ToString() + " & MonGain: " + story.monGain.ToString();
            this.lblQuantity.Text = "Enemies: " + story.numEnemies.ToString();

            int maxWidth = 0;
            int maxHeight = 0;

            for (int i = 0; i < flowLayoutPanel1.Controls.Count; i++) {
                int temp = flowLayoutPanel1.Controls[i].Width + flowLayoutPanel1.Margin.Left + flowLayoutPanel1.Margin.Right;
                if (maxWidth < temp) {
                    maxWidth = temp;
                }

                maxHeight += flowLayoutPanel1.Controls[i].Height;
            }

            this.Width = maxWidth;
            this.Height = maxHeight + flowLayoutPanel1.Margin.Top + flowLayoutPanel1.Margin.Bottom; ;
        }

        private void flowLayoutPanel1_MouseClick(object sender, MouseEventArgs e) {
            if (StoryForm.instance == null) new StoryForm(MainWindow.instance.story_storyPan.Controls[0] as StoryCacheControl);

            StoryForm.instance.Show();
            StoryForm.instance.Fill(story);
            MainWindow.instance.paintMode = PaintMode.Story;
        }
    }
}
