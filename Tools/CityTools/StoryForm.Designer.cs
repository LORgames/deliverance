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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtStartLocation = new System.Windows.Forms.TextBox();
            this.txtEndLocation = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.cmbNPCImage1 = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtRepLevel = new System.Windows.Forms.TextBox();
            this.txtQuantity = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.txtStartText = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.txtEndText = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.btnSave = new System.Windows.Forms.Button();
            this.cmbResourceType = new System.Windows.Forms.ComboBox();
            this.cmbNPCImage2 = new System.Windows.Forms.ComboBox();
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
            this.txtStartLocation.Location = new System.Drawing.Point(98, 12);
            this.txtStartLocation.Name = "txtStartLocation";
            this.txtStartLocation.Size = new System.Drawing.Size(272, 20);
            this.txtStartLocation.TabIndex = 0;
            // 
            // txtEndLocation
            // 
            this.txtEndLocation.Location = new System.Drawing.Point(98, 38);
            this.txtEndLocation.Name = "txtEndLocation";
            this.txtEndLocation.Size = new System.Drawing.Size(272, 20);
            this.txtEndLocation.TabIndex = 1;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 67);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(61, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "NPC Image";
            // 
            // cmbNPCImage1
            // 
            this.cmbNPCImage1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbNPCImage1.FormattingEnabled = true;
            this.cmbNPCImage1.Items.AddRange(new object[] {
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
            this.cmbNPCImage1.Location = new System.Drawing.Point(98, 64);
            this.cmbNPCImage1.Name = "cmbNPCImage1";
            this.cmbNPCImage1.Size = new System.Drawing.Size(133, 21);
            this.cmbNPCImage1.TabIndex = 2;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 94);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(56, 13);
            this.label4.TabIndex = 6;
            this.label4.Text = "Rep Level";
            // 
            // txtRepLevel
            // 
            this.txtRepLevel.Location = new System.Drawing.Point(98, 91);
            this.txtRepLevel.Name = "txtRepLevel";
            this.txtRepLevel.Size = new System.Drawing.Size(272, 20);
            this.txtRepLevel.TabIndex = 4;
            // 
            // txtQuantity
            // 
            this.txtQuantity.Location = new System.Drawing.Point(98, 143);
            this.txtQuantity.Name = "txtQuantity";
            this.txtQuantity.Size = new System.Drawing.Size(272, 20);
            this.txtQuantity.TabIndex = 6;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 120);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(80, 13);
            this.label5.TabIndex = 10;
            this.label5.Text = "Resource Type";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(12, 146);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(46, 13);
            this.label6.TabIndex = 11;
            this.label6.Text = "Quantity";
            // 
            // txtStartText
            // 
            this.txtStartText.Location = new System.Drawing.Point(98, 169);
            this.txtStartText.Multiline = true;
            this.txtStartText.Name = "txtStartText";
            this.txtStartText.Size = new System.Drawing.Size(272, 92);
            this.txtStartText.TabIndex = 7;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(12, 172);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(53, 13);
            this.label7.TabIndex = 13;
            this.label7.Text = "Start Text";
            // 
            // txtEndText
            // 
            this.txtEndText.Location = new System.Drawing.Point(98, 267);
            this.txtEndText.Multiline = true;
            this.txtEndText.Name = "txtEndText";
            this.txtEndText.Size = new System.Drawing.Size(272, 92);
            this.txtEndText.TabIndex = 8;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(12, 270);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(50, 13);
            this.label8.TabIndex = 15;
            this.label8.Text = "End Text";
            // 
            // btnSave
            // 
            this.btnSave.Location = new System.Drawing.Point(154, 365);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(75, 23);
            this.btnSave.TabIndex = 9;
            this.btnSave.Text = "Save";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // cmbResourceType
            // 
            this.cmbResourceType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbResourceType.FormattingEnabled = true;
            this.cmbResourceType.Items.AddRange(new object[] {
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
            "20",
            "21",
            "22",
            "23",
            "24",
            "25"});
            this.cmbResourceType.Location = new System.Drawing.Point(98, 117);
            this.cmbResourceType.Name = "cmbResourceType";
            this.cmbResourceType.Size = new System.Drawing.Size(272, 21);
            this.cmbResourceType.TabIndex = 5;
            // 
            // cmbNPCImage2
            // 
            this.cmbNPCImage2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbNPCImage2.FormattingEnabled = true;
            this.cmbNPCImage2.Items.AddRange(new object[] {
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
            this.cmbNPCImage2.Location = new System.Drawing.Point(237, 64);
            this.cmbNPCImage2.Name = "cmbNPCImage2";
            this.cmbNPCImage2.Size = new System.Drawing.Size(133, 21);
            this.cmbNPCImage2.TabIndex = 3;
            // 
            // StoryForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(382, 393);
            this.Controls.Add(this.cmbNPCImage2);
            this.Controls.Add(this.cmbResourceType);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.txtEndText);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.txtStartText);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.txtQuantity);
            this.Controls.Add(this.txtRepLevel);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.cmbNPCImage1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtEndLocation);
            this.Controls.Add(this.txtStartLocation);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "StoryForm";
            this.Text = "StoryForm";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.StoryForm_FormClosing);
            this.Shown += new System.EventHandler(this.StoryForm_Shown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtStartLocation;
        private System.Windows.Forms.TextBox txtEndLocation;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox cmbNPCImage1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtRepLevel;
        private System.Windows.Forms.TextBox txtQuantity;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txtStartText;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtEndText;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.ComboBox cmbResourceType;
        private System.Windows.Forms.ComboBox cmbNPCImage2;
    }
}