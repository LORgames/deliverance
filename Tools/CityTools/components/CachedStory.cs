﻿using System;
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
            this.lblNPCImage.Text = "NPC Image: " + story.npcImage1.ToString() + "_" + story.npcImage2.ToString();
            this.lblRepLevel.Text = "Rep Level: " + story.repLevel.ToString();
            this.lblResType.Text = "Res Type: " + story.resType.ToString();
            this.lblQuantity.Text = "Quantity: " + story.quantity.ToString();

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
            StoryForm.instance.Show();
            StoryForm.instance.Fill(story);
            MainWindow.instance.paintMode = PaintMode.Story;
        }
    }
}
