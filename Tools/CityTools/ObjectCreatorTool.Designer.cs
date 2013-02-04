namespace CityTools {
    partial class ObjectCreatorTool {
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
            this.main_splitter = new System.Windows.Forms.SplitContainer();
            this.button1 = new System.Windows.Forms.Button();
            this.circle_btn = new System.Windows.Forms.Button();
            this.square_btn = new System.Windows.Forms.Button();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.edge_btn = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.main_splitter)).BeginInit();
            this.main_splitter.Panel1.SuspendLayout();
            this.main_splitter.Panel2.SuspendLayout();
            this.main_splitter.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // main_splitter
            // 
            this.main_splitter.Dock = System.Windows.Forms.DockStyle.Fill;
            this.main_splitter.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.main_splitter.Location = new System.Drawing.Point(0, 0);
            this.main_splitter.Name = "main_splitter";
            // 
            // main_splitter.Panel1
            // 
            this.main_splitter.Panel1.Controls.Add(this.edge_btn);
            this.main_splitter.Panel1.Controls.Add(this.button1);
            this.main_splitter.Panel1.Controls.Add(this.circle_btn);
            this.main_splitter.Panel1.Controls.Add(this.square_btn);
            // 
            // main_splitter.Panel2
            // 
            this.main_splitter.Panel2.BackColor = System.Drawing.SystemColors.WindowFrame;
            this.main_splitter.Panel2.Controls.Add(this.pictureBox1);
            this.main_splitter.Size = new System.Drawing.Size(869, 463);
            this.main_splitter.SplitterDistance = 166;
            this.main_splitter.TabIndex = 1;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(3, 90);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(160, 23);
            this.button1.TabIndex = 5;
            this.button1.Text = "Clear Physics";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.setShape);
            // 
            // circle_btn
            // 
            this.circle_btn.Location = new System.Drawing.Point(3, 32);
            this.circle_btn.Name = "circle_btn";
            this.circle_btn.Size = new System.Drawing.Size(160, 23);
            this.circle_btn.TabIndex = 4;
            this.circle_btn.Text = "Circle";
            this.circle_btn.UseVisualStyleBackColor = true;
            this.circle_btn.Click += new System.EventHandler(this.setShape);
            // 
            // square_btn
            // 
            this.square_btn.Location = new System.Drawing.Point(3, 3);
            this.square_btn.Name = "square_btn";
            this.square_btn.Size = new System.Drawing.Size(160, 23);
            this.square_btn.TabIndex = 3;
            this.square_btn.Text = "Square";
            this.square_btn.UseVisualStyleBackColor = true;
            this.square_btn.Click += new System.EventHandler(this.setShape);
            // 
            // pictureBox1
            // 
            this.pictureBox1.BackColor = System.Drawing.Color.Transparent;
            this.pictureBox1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox1.Location = new System.Drawing.Point(0, 0);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(699, 463);
            this.pictureBox1.TabIndex = 0;
            this.pictureBox1.TabStop = false;
            this.pictureBox1.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBox1_Paint);
            this.pictureBox1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.pictureBox1_MouseDown);
            this.pictureBox1.MouseMove += new System.Windows.Forms.MouseEventHandler(this.pictureBox1_MouseMove);
            this.pictureBox1.MouseUp += new System.Windows.Forms.MouseEventHandler(this.pictureBox1_MouseUp);
            this.pictureBox1.Resize += new System.EventHandler(this.pictureBox1_Resize);
            // 
            // edge_btn
            // 
            this.edge_btn.Location = new System.Drawing.Point(3, 61);
            this.edge_btn.Name = "edge_btn";
            this.edge_btn.Size = new System.Drawing.Size(160, 23);
            this.edge_btn.TabIndex = 6;
            this.edge_btn.Text = "Edge";
            this.edge_btn.UseVisualStyleBackColor = true;
            this.edge_btn.Click += new System.EventHandler(this.setShape);
            // 
            // ObjectCreatorTool
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(869, 463);
            this.Controls.Add(this.main_splitter);
            this.Name = "ObjectCreatorTool";
            this.Text = "Scenic Object Editor";
            this.TopMost = true;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ObjectCreatorTool_FormClosing);
            this.main_splitter.Panel1.ResumeLayout(false);
            this.main_splitter.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.main_splitter)).EndInit();
            this.main_splitter.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer main_splitter;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button circle_btn;
        private System.Windows.Forms.Button square_btn;
        private System.Windows.Forms.Button edge_btn;
    }
}