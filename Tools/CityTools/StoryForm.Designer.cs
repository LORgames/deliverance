namespace CityTools {
    partial class StoryForm {
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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(StoryForm));
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtStartLocation = new System.Windows.Forms.TextBox();
            this.txtEndLocation = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.cmbStartNPCImage1 = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtRepLevel = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.txtStartText = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.txtEndText = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.btnSave = new System.Windows.Forms.Button();
            this.cmbStartNPCImage2 = new System.Windows.Forms.ComboBox();
            this.label9 = new System.Windows.Forms.Label();
            this.txtPickupText = new System.Windows.Forms.TextBox();
            this.cmbEndNPCImage2 = new System.Windows.Forms.ComboBox();
            this.cmbEndNPCImage1 = new System.Windows.Forms.ComboBox();
            this.label10 = new System.Windows.Forms.Label();
            this.pbStartNPC = new System.Windows.Forms.PictureBox();
            this.pbEndNPC = new System.Windows.Forms.PictureBox();
            this.tbEnemyQTY = new System.Windows.Forms.TrackBar();
            this.txtReputationGain = new System.Windows.Forms.TextBox();
            this.txtMonetaryGain = new System.Windows.Forms.TextBox();
            this.label11 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.linkLabel2 = new System.Windows.Forms.LinkLabel();
            ((System.ComponentModel.ISupportInitialize)(this.pbStartNPC)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbEndNPC)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbEnemyQTY)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 15);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(73, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Start Location";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 41);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(70, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "End Location";
            // 
            // txtStartLocation
            // 
            this.txtStartLocation.Location = new System.Drawing.Point(88, 12);
            this.txtStartLocation.Name = "txtStartLocation";
            this.txtStartLocation.Size = new System.Drawing.Size(129, 20);
            this.txtStartLocation.TabIndex = 0;
            // 
            // txtEndLocation
            // 
            this.txtEndLocation.Location = new System.Drawing.Point(88, 38);
            this.txtEndLocation.Name = "txtEndLocation";
            this.txtEndLocation.Size = new System.Drawing.Size(129, 20);
            this.txtEndLocation.TabIndex = 1;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 67);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(54, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "Start NPC";
            // 
            // cmbStartNPCImage1
            // 
            this.cmbStartNPCImage1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbStartNPCImage1.FormattingEnabled = true;
            this.cmbStartNPCImage1.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20"});
            this.cmbStartNPCImage1.Location = new System.Drawing.Point(88, 64);
            this.cmbStartNPCImage1.Name = "cmbStartNPCImage1";
            this.cmbStartNPCImage1.Size = new System.Drawing.Size(88, 21);
            this.cmbStartNPCImage1.TabIndex = 2;
            this.cmbStartNPCImage1.SelectedIndexChanged += new System.EventHandler(this.cmbNPCImage_SelectedIndexChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 124);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(73, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "Rep Required";
            // 
            // txtRepLevel
            // 
            this.txtRepLevel.Location = new System.Drawing.Point(88, 121);
            this.txtRepLevel.Name = "txtRepLevel";
            this.txtRepLevel.Size = new System.Drawing.Size(129, 20);
            this.txtRepLevel.TabIndex = 4;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 150);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(65, 13);
            this.label5.TabIndex = 10;
            this.label5.Text = "Reputation+";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(12, 202);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(47, 13);
            this.label6.TabIndex = 11;
            this.label6.Text = "Enemies";
            // 
            // txtStartText
            // 
            this.txtStartText.Location = new System.Drawing.Point(82, 258);
            this.txtStartText.Multiline = true;
            this.txtStartText.Name = "txtStartText";
            this.txtStartText.Size = new System.Drawing.Size(320, 92);
            this.txtStartText.TabIndex = 7;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(12, 261);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(53, 13);
            this.label7.TabIndex = 13;
            this.label7.Text = "Start Text";
            // 
            // txtEndText
            // 
            this.txtEndText.Location = new System.Drawing.Point(82, 454);
            this.txtEndText.Multiline = true;
            this.txtEndText.Name = "txtEndText";
            this.txtEndText.Size = new System.Drawing.Size(320, 92);
            this.txtEndText.TabIndex = 8;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(12, 454);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(50, 13);
            this.label8.TabIndex = 15;
            this.label8.Text = "End Text";
            // 
            // btnSave
            // 
            this.btnSave.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.btnSave.Location = new System.Drawing.Point(0, 552);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(577, 23);
            this.btnSave.TabIndex = 9;
            this.btnSave.Text = "Save";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // cmbStartNPCImage2
            // 
            this.cmbStartNPCImage2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbStartNPCImage2.FormattingEnabled = true;
            this.cmbStartNPCImage2.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20"});
            this.cmbStartNPCImage2.Location = new System.Drawing.Point(182, 64);
            this.cmbStartNPCImage2.Name = "cmbStartNPCImage2";
            this.cmbStartNPCImage2.Size = new System.Drawing.Size(35, 21);
            this.cmbStartNPCImage2.TabIndex = 3;
            this.cmbStartNPCImage2.SelectedIndexChanged += new System.EventHandler(this.UpdateNPCPicture);
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(12, 356);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(64, 13);
            this.label9.TabIndex = 17;
            this.label9.Text = "Pickup Text";
            // 
            // txtPickupText
            // 
            this.txtPickupText.Location = new System.Drawing.Point(82, 356);
            this.txtPickupText.Multiline = true;
            this.txtPickupText.Name = "txtPickupText";
            this.txtPickupText.Size = new System.Drawing.Size(320, 92);
            this.txtPickupText.TabIndex = 16;
            // 
            // cmbEndNPCImage2
            // 
            this.cmbEndNPCImage2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEndNPCImage2.FormattingEnabled = true;
            this.cmbEndNPCImage2.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20"});
            this.cmbEndNPCImage2.Location = new System.Drawing.Point(182, 93);
            this.cmbEndNPCImage2.Name = "cmbEndNPCImage2";
            this.cmbEndNPCImage2.Size = new System.Drawing.Size(35, 21);
            this.cmbEndNPCImage2.TabIndex = 20;
            this.cmbEndNPCImage2.SelectedIndexChanged += new System.EventHandler(this.UpdateNPCPicture);
            // 
            // cmbEndNPCImage1
            // 
            this.cmbEndNPCImage1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbEndNPCImage1.FormattingEnabled = true;
            this.cmbEndNPCImage1.Items.AddRange(new object[] {
            "0",
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10",
            "11",
            "12",
            "13",
            "14",
            "15",
            "16",
            "17",
            "18",
            "19",
            "20"});
            this.cmbEndNPCImage1.Location = new System.Drawing.Point(88, 93);
            this.cmbEndNPCImage1.Name = "cmbEndNPCImage1";
            this.cmbEndNPCImage1.Size = new System.Drawing.Size(88, 21);
            this.cmbEndNPCImage1.TabIndex = 19;
            this.cmbEndNPCImage1.SelectedIndexChanged += new System.EventHandler(this.cmbNPCImage_SelectedIndexChanged);
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(12, 96);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(51, 13);
            this.label10.TabIndex = 21;
            this.label10.Text = "End NPC";
            // 
            // pbStartNPC
            // 
            this.pbStartNPC.Location = new System.Drawing.Point(223, 12);
            this.pbStartNPC.Name = "pbStartNPC";
            this.pbStartNPC.Size = new System.Drawing.Size(168, 240);
            this.pbStartNPC.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pbStartNPC.TabIndex = 22;
            this.pbStartNPC.TabStop = false;
            // 
            // pbEndNPC
            // 
            this.pbEndNPC.Location = new System.Drawing.Point(397, 9);
            this.pbEndNPC.Name = "pbEndNPC";
            this.pbEndNPC.Size = new System.Drawing.Size(168, 243);
            this.pbEndNPC.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pbEndNPC.TabIndex = 23;
            this.pbEndNPC.TabStop = false;
            // 
            // tbEnemyQTY
            // 
            this.tbEnemyQTY.Location = new System.Drawing.Point(88, 195);
            this.tbEnemyQTY.Maximum = 20;
            this.tbEnemyQTY.Name = "tbEnemyQTY";
            this.tbEnemyQTY.Size = new System.Drawing.Size(129, 45);
            this.tbEnemyQTY.TabIndex = 24;
            // 
            // txtReputationGain
            // 
            this.txtReputationGain.Location = new System.Drawing.Point(88, 147);
            this.txtReputationGain.Name = "txtReputationGain";
            this.txtReputationGain.Size = new System.Drawing.Size(129, 20);
            this.txtReputationGain.TabIndex = 25;
            // 
            // txtMonetaryGain
            // 
            this.txtMonetaryGain.Location = new System.Drawing.Point(88, 173);
            this.txtMonetaryGain.Name = "txtMonetaryGain";
            this.txtMonetaryGain.Size = new System.Drawing.Size(129, 20);
            this.txtMonetaryGain.TabIndex = 27;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(12, 173);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(45, 13);
            this.label11.TabIndex = 26;
            this.label11.Text = "Money+";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(411, 258);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ReadOnly = true;
            this.textBox1.Size = new System.Drawing.Size(154, 272);
            this.textBox1.TabIndex = 28;
            this.textBox1.Text = resources.GetString("textBox1.Text");
            // 
            // linkLabel2
            // 
            this.linkLabel2.AutoSize = true;
            this.linkLabel2.Location = new System.Drawing.Point(438, 533);
            this.linkLabel2.Name = "linkLabel2";
            this.linkLabel2.Size = new System.Drawing.Size(127, 13);
            this.linkLabel2.TabIndex = 30;
            this.linkLabel2.TabStop = true;
            this.linkLabel2.Text = "AS3 Allowed HTML Tags";
            this.linkLabel2.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkLabel2_LinkClicked);
            // 
            // StoryForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(577, 575);
            this.Controls.Add(this.linkLabel2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.txtMonetaryGain);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.txtReputationGain);
            this.Controls.Add(this.txtStartText);
            this.Controls.Add(this.tbEnemyQTY);
            this.Controls.Add(this.pbEndNPC);
            this.Controls.Add(this.pbStartNPC);
            this.Controls.Add(this.cmbEndNPCImage2);
            this.Controls.Add(this.cmbEndNPCImage1);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.txtPickupText);
            this.Controls.Add(this.cmbStartNPCImage2);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.txtEndText);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.txtRepLevel);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.cmbStartNPCImage1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtEndLocation);
            this.Controls.Add(this.txtStartLocation);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "StoryForm";
            this.Text = "StoryForm";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.StoryForm_FormClosing);
            this.Shown += new System.EventHandler(this.StoryForm_Shown);
            ((System.ComponentModel.ISupportInitialize)(this.pbStartNPC)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbEndNPC)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbEnemyQTY)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtStartLocation;
        private System.Windows.Forms.TextBox txtEndLocation;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox cmbStartNPCImage1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtRepLevel;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtStartText;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtEndText;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.ComboBox cmbStartNPCImage2;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox txtPickupText;
        private System.Windows.Forms.ComboBox cmbEndNPCImage2;
        private System.Windows.Forms.ComboBox cmbEndNPCImage1;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.PictureBox pbStartNPC;
        private System.Windows.Forms.PictureBox pbEndNPC;
        private System.Windows.Forms.TrackBar tbEnemyQTY;
        private System.Windows.Forms.TextBox txtReputationGain;
        private System.Windows.Forms.TextBox txtMonetaryGain;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.LinkLabel linkLabel2;
    }
}