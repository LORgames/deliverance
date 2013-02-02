namespace CityTools.Components {
    partial class CachedStory {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.lblStartLocation = new System.Windows.Forms.Label();
            this.lblEndLocation = new System.Windows.Forms.Label();
            this.lblNPCImage = new System.Windows.Forms.Label();
            this.lblRepLevel = new System.Windows.Forms.Label();
            this.lblResType = new System.Windows.Forms.Label();
            this.lblQuantity = new System.Windows.Forms.Label();
            this.flowLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.Controls.Add(this.lblStartLocation);
            this.flowLayoutPanel1.Controls.Add(this.lblEndLocation);
            this.flowLayoutPanel1.Controls.Add(this.lblNPCImage);
            this.flowLayoutPanel1.Controls.Add(this.lblRepLevel);
            this.flowLayoutPanel1.Controls.Add(this.lblResType);
            this.flowLayoutPanel1.Controls.Add(this.lblQuantity);
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(251, 150);
            this.flowLayoutPanel1.TabIndex = 0;
            this.flowLayoutPanel1.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // lblStartLocation
            // 
            this.lblStartLocation.AutoSize = true;
            this.lblStartLocation.Location = new System.Drawing.Point(3, 0);
            this.lblStartLocation.Name = "lblStartLocation";
            this.lblStartLocation.Size = new System.Drawing.Size(103, 13);
            this.lblStartLocation.TabIndex = 0;
            this.lblStartLocation.Text = "Start Location: 0000";
            this.lblStartLocation.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // lblEndLocation
            // 
            this.lblEndLocation.AutoSize = true;
            this.lblEndLocation.Location = new System.Drawing.Point(3, 13);
            this.lblEndLocation.Name = "lblEndLocation";
            this.lblEndLocation.Size = new System.Drawing.Size(100, 13);
            this.lblEndLocation.TabIndex = 1;
            this.lblEndLocation.Text = "End Location: 0000";
            this.lblEndLocation.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // lblNPCImage
            // 
            this.lblNPCImage.AutoSize = true;
            this.lblNPCImage.Location = new System.Drawing.Point(3, 26);
            this.lblNPCImage.Name = "lblNPCImage";
            this.lblNPCImage.Size = new System.Drawing.Size(79, 13);
            this.lblNPCImage.TabIndex = 2;
            this.lblNPCImage.Text = "NPC Image: 00";
            this.lblNPCImage.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // lblRepLevel
            // 
            this.lblRepLevel.AutoSize = true;
            this.lblRepLevel.Location = new System.Drawing.Point(3, 39);
            this.lblRepLevel.Name = "lblRepLevel";
            this.lblRepLevel.Size = new System.Drawing.Size(104, 13);
            this.lblRepLevel.TabIndex = 3;
            this.lblRepLevel.Text = "Rep Level: 0000000";
            this.lblRepLevel.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // lblResType
            // 
            this.lblResType.AutoSize = true;
            this.lblResType.Location = new System.Drawing.Point(3, 52);
            this.lblResType.Name = "lblResType";
            this.lblResType.Size = new System.Drawing.Size(146, 13);
            this.lblResType.TabIndex = 4;
            this.lblResType.Text = "Res Type: WORDS WORDS";
            this.lblResType.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // lblQuantity
            // 
            this.lblQuantity.AutoSize = true;
            this.lblQuantity.Location = new System.Drawing.Point(3, 65);
            this.lblQuantity.Name = "lblQuantity";
            this.lblQuantity.Size = new System.Drawing.Size(88, 13);
            this.lblQuantity.TabIndex = 5;
            this.lblQuantity.Text = "Quantity: 000000";
            this.lblQuantity.MouseClick += new System.Windows.Forms.MouseEventHandler(this.flowLayoutPanel1_MouseClick);
            // 
            // CachedStory
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.flowLayoutPanel1);
            this.Name = "CachedStory";
            this.Size = new System.Drawing.Size(251, 150);
            this.flowLayoutPanel1.ResumeLayout(false);
            this.flowLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.Label lblStartLocation;
        private System.Windows.Forms.Label lblEndLocation;
        private System.Windows.Forms.Label lblNPCImage;
        private System.Windows.Forms.Label lblRepLevel;
        private System.Windows.Forms.Label lblResType;
        private System.Windows.Forms.Label lblQuantity;

    }
}
