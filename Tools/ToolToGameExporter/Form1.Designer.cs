namespace ToolToGameExporter {
    partial class Form1 {
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
            this.tool_loc_TB = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.game_loc_TB = new System.Windows.Forms.TextBox();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.game_btn = new System.Windows.Forms.Button();
            this.tool_btn = new System.Windows.Forms.Button();
            this.convert_btn = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // tool_loc_TB
            // 
            this.tool_loc_TB.Location = new System.Drawing.Point(12, 27);
            this.tool_loc_TB.Name = "tool_loc_TB";
            this.tool_loc_TB.ReadOnly = true;
            this.tool_loc_TB.Size = new System.Drawing.Size(179, 20);
            this.tool_loc_TB.TabIndex = 0;
            this.tool_loc_TB.Text = "./";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(75, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Tool Location:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(9, 66);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(82, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Game Location:";
            // 
            // game_loc_TB
            // 
            this.game_loc_TB.Location = new System.Drawing.Point(12, 84);
            this.game_loc_TB.Name = "game_loc_TB";
            this.game_loc_TB.ReadOnly = true;
            this.game_loc_TB.Size = new System.Drawing.Size(179, 20);
            this.game_loc_TB.TabIndex = 2;
            this.game_loc_TB.Text = "../CityGame/";
            // 
            // game_btn
            // 
            this.game_btn.Location = new System.Drawing.Point(197, 81);
            this.game_btn.Name = "game_btn";
            this.game_btn.Size = new System.Drawing.Size(75, 23);
            this.game_btn.TabIndex = 4;
            this.game_btn.Text = "Browse";
            this.game_btn.UseVisualStyleBackColor = true;
            this.game_btn.Click += new System.EventHandler(this.game_btn_Click);
            // 
            // tool_btn
            // 
            this.tool_btn.Location = new System.Drawing.Point(197, 27);
            this.tool_btn.Name = "tool_btn";
            this.tool_btn.Size = new System.Drawing.Size(75, 23);
            this.tool_btn.TabIndex = 4;
            this.tool_btn.Text = "Browse";
            this.tool_btn.UseVisualStyleBackColor = true;
            this.tool_btn.Click += new System.EventHandler(this.tool_btn_Click);
            // 
            // convert_btn
            // 
            this.convert_btn.Location = new System.Drawing.Point(12, 137);
            this.convert_btn.Name = "convert_btn";
            this.convert_btn.Size = new System.Drawing.Size(260, 23);
            this.convert_btn.TabIndex = 4;
            this.convert_btn.Text = "Convert For Game";
            this.convert_btn.UseVisualStyleBackColor = true;
            this.convert_btn.Click += new System.EventHandler(this.convert_btn_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 166);
            this.Controls.Add(this.tool_btn);
            this.Controls.Add(this.convert_btn);
            this.Controls.Add(this.game_btn);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.game_loc_TB);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.tool_loc_TB);
            this.Name = "Form1";
            this.Text = "Exporter";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox tool_loc_TB;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox game_loc_TB;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.Button game_btn;
        private System.Windows.Forms.Button tool_btn;
        private System.Windows.Forms.Button convert_btn;
    }
}

