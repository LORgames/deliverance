namespace CityTools.Components {
    partial class ObjectCacheControl {
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
            this.components = new System.ComponentModel.Container();
            this.flowLayoutPanel1 = new System.Windows.Forms.FlowLayoutPanel();
            this.objCache_contextMenu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.editObjectDetailsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboveTraffixToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.belowTraffixToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.objCache_contextMenu.SuspendLayout();
            this.SuspendLayout();
            // 
            // flowLayoutPanel1
            // 
            this.flowLayoutPanel1.AutoScroll = true;
            this.flowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flowLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.flowLayoutPanel1.Name = "flowLayoutPanel1";
            this.flowLayoutPanel1.Size = new System.Drawing.Size(209, 170);
            this.flowLayoutPanel1.TabIndex = 0;
            // 
            // objCache_contextMenu
            // 
            this.objCache_contextMenu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.editObjectDetailsToolStripMenuItem,
            this.aboveTraffixToolStripMenuItem,
            this.belowTraffixToolStripMenuItem});
            this.objCache_contextMenu.Name = "objCache_contextMenu";
            this.objCache_contextMenu.Size = new System.Drawing.Size(153, 92);
            // 
            // editObjectDetailsToolStripMenuItem
            // 
            this.editObjectDetailsToolStripMenuItem.Name = "editObjectDetailsToolStripMenuItem";
            this.editObjectDetailsToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.editObjectDetailsToolStripMenuItem.Text = "Edit Physics";
            this.editObjectDetailsToolStripMenuItem.Click += new System.EventHandler(this.editObjectDetailsToolStripMenuItem_Click);
            // 
            // aboveTraffixToolStripMenuItem
            // 
            this.aboveTraffixToolStripMenuItem.Name = "aboveTraffixToolStripMenuItem";
            this.aboveTraffixToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.aboveTraffixToolStripMenuItem.Text = "Above Traffic";
            this.aboveTraffixToolStripMenuItem.Click += new System.EventHandler(this.requestedLayerChange);
            // 
            // belowTraffixToolStripMenuItem
            // 
            this.belowTraffixToolStripMenuItem.Name = "belowTraffixToolStripMenuItem";
            this.belowTraffixToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.belowTraffixToolStripMenuItem.Text = "Below Traffic";
            this.belowTraffixToolStripMenuItem.Click += new System.EventHandler(this.requestedLayerChange);
            // 
            // ObjectCacheControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.flowLayoutPanel1);
            this.Name = "ObjectCacheControl";
            this.Size = new System.Drawing.Size(209, 170);
            this.objCache_contextMenu.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.FlowLayoutPanel flowLayoutPanel1;
        private System.Windows.Forms.ContextMenuStrip objCache_contextMenu;
        private System.Windows.Forms.ToolStripMenuItem editObjectDetailsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboveTraffixToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem belowTraffixToolStripMenuItem;
    }
}
