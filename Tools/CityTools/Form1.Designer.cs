namespace CityTools
{
    partial class MainWindow
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.main_splitter = new System.Windows.Forms.SplitContainer();
            this.mapViewPanel_c = new System.Windows.Forms.Panel();
            this.mapViewPanel = new System.Windows.Forms.PictureBox();
            this.toolpanel_splitter = new System.Windows.Forms.SplitContainer();
            this.minimap = new System.Windows.Forms.PictureBox();
            this.layer_ceiling = new System.Windows.Forms.CheckBox();
            this.layer_objects = new System.Windows.Forms.CheckBox();
            this.layer_floor = new System.Windows.Forms.CheckBox();
            this.tool_tabs = new System.Windows.Forms.TabControl();
            this.terrain_tab = new System.Windows.Forms.TabPage();
            this.flush_textureCache = new System.Windows.Forms.Button();
            this.texture_btn = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.terrain_penSize = new System.Windows.Forms.NumericUpDown();
            this.terrain_shape_btn = new System.Windows.Forms.Button();
            this.pen_btn = new System.Windows.Forms.Button();
            this.colour_btn = new System.Windows.Forms.Button();
            this.objects_tab = new System.Windows.Forms.TabPage();
            this.obj_splitter = new System.Windows.Forms.SplitContainer();
            this.obj_flipY = new System.Windows.Forms.CheckBox();
            this.obj_flipX = new System.Windows.Forms.CheckBox();
            this.obj_scale = new System.Windows.Forms.NumericUpDown();
            this.obj_rot = new System.Windows.Forms.NumericUpDown();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.obj_cats = new System.Windows.Forms.TabControl();
            this.obj_collection_buildings = new System.Windows.Forms.TabPage();
            this.obj_collection_roads = new System.Windows.Forms.TabPage();
            this.obj_collection_environment = new System.Windows.Forms.TabPage();
            this.physics_tab = new System.Windows.Forms.TabPage();
            this.nodes_tab = new System.Windows.Forms.TabPage();
            this.places_tab = new System.Windows.Forms.TabPage();
            this.colorDialog1 = new System.Windows.Forms.ColorDialog();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            ((System.ComponentModel.ISupportInitialize)(this.main_splitter)).BeginInit();
            this.main_splitter.Panel1.SuspendLayout();
            this.main_splitter.Panel2.SuspendLayout();
            this.main_splitter.SuspendLayout();
            this.mapViewPanel_c.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.mapViewPanel)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.toolpanel_splitter)).BeginInit();
            this.toolpanel_splitter.Panel1.SuspendLayout();
            this.toolpanel_splitter.Panel2.SuspendLayout();
            this.toolpanel_splitter.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.minimap)).BeginInit();
            this.tool_tabs.SuspendLayout();
            this.terrain_tab.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.terrain_penSize)).BeginInit();
            this.objects_tab.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.obj_splitter)).BeginInit();
            this.obj_splitter.Panel1.SuspendLayout();
            this.obj_splitter.Panel2.SuspendLayout();
            this.obj_splitter.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.obj_scale)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.obj_rot)).BeginInit();
            this.obj_cats.SuspendLayout();
            this.SuspendLayout();
            // 
            // main_splitter
            // 
            this.main_splitter.Dock = System.Windows.Forms.DockStyle.Fill;
            this.main_splitter.FixedPanel = System.Windows.Forms.FixedPanel.Panel2;
            this.main_splitter.IsSplitterFixed = true;
            this.main_splitter.Location = new System.Drawing.Point(0, 0);
            this.main_splitter.Name = "main_splitter";
            // 
            // main_splitter.Panel1
            // 
            this.main_splitter.Panel1.Controls.Add(this.mapViewPanel_c);
            // 
            // main_splitter.Panel2
            // 
            this.main_splitter.Panel2.Controls.Add(this.toolpanel_splitter);
            this.main_splitter.Size = new System.Drawing.Size(853, 398);
            this.main_splitter.SplitterDistance = 618;
            this.main_splitter.TabIndex = 0;
            // 
            // mapViewPanel_c
            // 
            this.mapViewPanel_c.Controls.Add(this.mapViewPanel);
            this.mapViewPanel_c.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mapViewPanel_c.Location = new System.Drawing.Point(0, 0);
            this.mapViewPanel_c.Name = "mapViewPanel_c";
            this.mapViewPanel_c.Size = new System.Drawing.Size(618, 398);
            this.mapViewPanel_c.TabIndex = 0;
            // 
            // mapViewPanel
            // 
            this.mapViewPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mapViewPanel.Location = new System.Drawing.Point(0, 0);
            this.mapViewPanel.Name = "mapViewPanel";
            this.mapViewPanel.Size = new System.Drawing.Size(618, 398);
            this.mapViewPanel.TabIndex = 0;
            this.mapViewPanel.TabStop = false;
            this.mapViewPanel.Paint += new System.Windows.Forms.PaintEventHandler(this.mapViewPanel_Paint);
            this.mapViewPanel.MouseDown += new System.Windows.Forms.MouseEventHandler(this.drawPanel_ME_move);
            this.mapViewPanel.MouseMove += new System.Windows.Forms.MouseEventHandler(this.drawPanel_ME_move);
            this.mapViewPanel.MouseUp += new System.Windows.Forms.MouseEventHandler(this.drawPanel_ME_up);
            this.mapViewPanel.Resize += new System.EventHandler(this.mapViewPanel_Resize);
            // 
            // toolpanel_splitter
            // 
            this.toolpanel_splitter.Dock = System.Windows.Forms.DockStyle.Fill;
            this.toolpanel_splitter.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.toolpanel_splitter.IsSplitterFixed = true;
            this.toolpanel_splitter.Location = new System.Drawing.Point(0, 0);
            this.toolpanel_splitter.Name = "toolpanel_splitter";
            this.toolpanel_splitter.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // toolpanel_splitter.Panel1
            // 
            this.toolpanel_splitter.Panel1.Controls.Add(this.minimap);
            this.toolpanel_splitter.Panel1.Controls.Add(this.layer_ceiling);
            this.toolpanel_splitter.Panel1.Controls.Add(this.layer_objects);
            this.toolpanel_splitter.Panel1.Controls.Add(this.layer_floor);
            // 
            // toolpanel_splitter.Panel2
            // 
            this.toolpanel_splitter.Panel2.Controls.Add(this.tool_tabs);
            this.toolpanel_splitter.Size = new System.Drawing.Size(231, 398);
            this.toolpanel_splitter.SplitterDistance = 250;
            this.toolpanel_splitter.TabIndex = 0;
            // 
            // minimap
            // 
            this.minimap.Location = new System.Drawing.Point(0, 0);
            this.minimap.Name = "minimap";
            this.minimap.Size = new System.Drawing.Size(231, 224);
            this.minimap.TabIndex = 3;
            this.minimap.TabStop = false;
            this.minimap.Paint += new System.Windows.Forms.PaintEventHandler(this.minimap_Paint);
            this.minimap.MouseClick += new System.Windows.Forms.MouseEventHandler(this.minimap_MouseClick);
            // 
            // layer_ceiling
            // 
            this.layer_ceiling.AutoSize = true;
            this.layer_ceiling.Location = new System.Drawing.Point(150, 230);
            this.layer_ceiling.Name = "layer_ceiling";
            this.layer_ceiling.Size = new System.Drawing.Size(77, 17);
            this.layer_ceiling.TabIndex = 2;
            this.layer_ceiling.Text = "Flying Objs";
            this.layer_ceiling.UseVisualStyleBackColor = true;
            this.layer_ceiling.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // layer_objects
            // 
            this.layer_objects.AutoSize = true;
            this.layer_objects.Checked = true;
            this.layer_objects.CheckState = System.Windows.Forms.CheckState.Checked;
            this.layer_objects.Location = new System.Drawing.Point(59, 230);
            this.layer_objects.Name = "layer_objects";
            this.layer_objects.Size = new System.Drawing.Size(85, 17);
            this.layer_objects.TabIndex = 1;
            this.layer_objects.Text = "Ground Objs";
            this.layer_objects.UseVisualStyleBackColor = true;
            this.layer_objects.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // layer_floor
            // 
            this.layer_floor.AutoSize = true;
            this.layer_floor.Checked = true;
            this.layer_floor.CheckState = System.Windows.Forms.CheckState.Checked;
            this.layer_floor.Location = new System.Drawing.Point(4, 230);
            this.layer_floor.Name = "layer_floor";
            this.layer_floor.Size = new System.Drawing.Size(49, 17);
            this.layer_floor.TabIndex = 0;
            this.layer_floor.Text = "Floor";
            this.layer_floor.UseVisualStyleBackColor = true;
            this.layer_floor.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // tool_tabs
            // 
            this.tool_tabs.Controls.Add(this.terrain_tab);
            this.tool_tabs.Controls.Add(this.objects_tab);
            this.tool_tabs.Controls.Add(this.physics_tab);
            this.tool_tabs.Controls.Add(this.nodes_tab);
            this.tool_tabs.Controls.Add(this.places_tab);
            this.tool_tabs.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tool_tabs.Location = new System.Drawing.Point(0, 0);
            this.tool_tabs.Name = "tool_tabs";
            this.tool_tabs.SelectedIndex = 0;
            this.tool_tabs.Size = new System.Drawing.Size(231, 144);
            this.tool_tabs.TabIndex = 0;
            // 
            // terrain_tab
            // 
            this.terrain_tab.Controls.Add(this.flush_textureCache);
            this.terrain_tab.Controls.Add(this.texture_btn);
            this.terrain_tab.Controls.Add(this.label1);
            this.terrain_tab.Controls.Add(this.terrain_penSize);
            this.terrain_tab.Controls.Add(this.terrain_shape_btn);
            this.terrain_tab.Controls.Add(this.pen_btn);
            this.terrain_tab.Controls.Add(this.colour_btn);
            this.terrain_tab.Location = new System.Drawing.Point(4, 22);
            this.terrain_tab.Name = "terrain_tab";
            this.terrain_tab.Padding = new System.Windows.Forms.Padding(3);
            this.terrain_tab.Size = new System.Drawing.Size(223, 118);
            this.terrain_tab.TabIndex = 0;
            this.terrain_tab.Text = "Terrain";
            this.terrain_tab.UseVisualStyleBackColor = true;
            // 
            // flush_textureCache
            // 
            this.flush_textureCache.Location = new System.Drawing.Point(6, 67);
            this.flush_textureCache.Name = "flush_textureCache";
            this.flush_textureCache.Size = new System.Drawing.Size(105, 23);
            this.flush_textureCache.TabIndex = 5;
            this.flush_textureCache.Text = "Flush";
            this.flush_textureCache.UseVisualStyleBackColor = true;
            this.flush_textureCache.Click += new System.EventHandler(this.flush_textureCache_Click);
            // 
            // texture_btn
            // 
            this.texture_btn.Location = new System.Drawing.Point(117, 35);
            this.texture_btn.Name = "texture_btn";
            this.texture_btn.Size = new System.Drawing.Size(98, 23);
            this.texture_btn.TabIndex = 4;
            this.texture_btn.Text = "Pick Texture";
            this.texture_btn.UseVisualStyleBackColor = true;
            this.texture_btn.Click += new System.EventHandler(this.texture_btn_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(114, 72);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Pen Size";
            // 
            // terrain_penSize
            // 
            this.terrain_penSize.Location = new System.Drawing.Point(167, 68);
            this.terrain_penSize.Maximum = new decimal(new int[] {
            1000,
            0,
            0,
            0});
            this.terrain_penSize.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.terrain_penSize.Name = "terrain_penSize";
            this.terrain_penSize.Size = new System.Drawing.Size(51, 20);
            this.terrain_penSize.TabIndex = 2;
            this.terrain_penSize.Value = new decimal(new int[] {
            100,
            0,
            0,
            0});
            // 
            // terrain_shape_btn
            // 
            this.terrain_shape_btn.Location = new System.Drawing.Point(117, 6);
            this.terrain_shape_btn.Name = "terrain_shape_btn";
            this.terrain_shape_btn.Size = new System.Drawing.Size(98, 23);
            this.terrain_shape_btn.TabIndex = 1;
            this.terrain_shape_btn.Text = "Shape (Circle)";
            this.terrain_shape_btn.UseVisualStyleBackColor = true;
            this.terrain_shape_btn.Click += new System.EventHandler(this.terrain_shape_btn_Click);
            // 
            // pen_btn
            // 
            this.pen_btn.Location = new System.Drawing.Point(6, 6);
            this.pen_btn.Name = "pen_btn";
            this.pen_btn.Size = new System.Drawing.Size(105, 23);
            this.pen_btn.TabIndex = 1;
            this.pen_btn.Text = "Pen Tool (Off)";
            this.pen_btn.UseVisualStyleBackColor = true;
            this.pen_btn.Click += new System.EventHandler(this.pen_btn_Click);
            // 
            // colour_btn
            // 
            this.colour_btn.Location = new System.Drawing.Point(6, 35);
            this.colour_btn.Name = "colour_btn";
            this.colour_btn.Size = new System.Drawing.Size(105, 23);
            this.colour_btn.TabIndex = 0;
            this.colour_btn.Text = "Pick Colour";
            this.colour_btn.UseVisualStyleBackColor = true;
            this.colour_btn.Click += new System.EventHandler(this.colour_btn_Click);
            // 
            // objects_tab
            // 
            this.objects_tab.Controls.Add(this.obj_splitter);
            this.objects_tab.Location = new System.Drawing.Point(4, 22);
            this.objects_tab.Name = "objects_tab";
            this.objects_tab.Padding = new System.Windows.Forms.Padding(3);
            this.objects_tab.Size = new System.Drawing.Size(223, 118);
            this.objects_tab.TabIndex = 1;
            this.objects_tab.Text = "Objects";
            this.objects_tab.UseVisualStyleBackColor = true;
            // 
            // obj_splitter
            // 
            this.obj_splitter.Dock = System.Windows.Forms.DockStyle.Fill;
            this.obj_splitter.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.obj_splitter.IsSplitterFixed = true;
            this.obj_splitter.Location = new System.Drawing.Point(3, 3);
            this.obj_splitter.Name = "obj_splitter";
            this.obj_splitter.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // obj_splitter.Panel1
            // 
            this.obj_splitter.Panel1.Controls.Add(this.obj_flipY);
            this.obj_splitter.Panel1.Controls.Add(this.obj_flipX);
            this.obj_splitter.Panel1.Controls.Add(this.obj_scale);
            this.obj_splitter.Panel1.Controls.Add(this.obj_rot);
            this.obj_splitter.Panel1.Controls.Add(this.label3);
            this.obj_splitter.Panel1.Controls.Add(this.label2);
            // 
            // obj_splitter.Panel2
            // 
            this.obj_splitter.Panel2.Controls.Add(this.obj_cats);
            this.obj_splitter.Size = new System.Drawing.Size(217, 112);
            this.obj_splitter.SplitterDistance = 61;
            this.obj_splitter.TabIndex = 0;
            // 
            // obj_flipY
            // 
            this.obj_flipY.AutoSize = true;
            this.obj_flipY.Location = new System.Drawing.Point(128, 23);
            this.obj_flipY.Name = "obj_flipY";
            this.obj_flipY.Size = new System.Drawing.Size(49, 17);
            this.obj_flipY.TabIndex = 4;
            this.obj_flipY.Text = "FlipY";
            this.obj_flipY.UseVisualStyleBackColor = true;
            // 
            // obj_flipX
            // 
            this.obj_flipX.AutoSize = true;
            this.obj_flipX.Location = new System.Drawing.Point(128, 3);
            this.obj_flipX.Name = "obj_flipX";
            this.obj_flipX.Size = new System.Drawing.Size(49, 17);
            this.obj_flipX.TabIndex = 4;
            this.obj_flipX.Text = "FlipX";
            this.obj_flipX.UseVisualStyleBackColor = true;
            // 
            // obj_scale
            // 
            this.obj_scale.Increment = new decimal(new int[] {
            25,
            0,
            0,
            131072});
            this.obj_scale.Location = new System.Drawing.Point(51, 24);
            this.obj_scale.Maximum = new decimal(new int[] {
            2,
            0,
            0,
            0});
            this.obj_scale.Minimum = new decimal(new int[] {
            25,
            0,
            0,
            131072});
            this.obj_scale.Name = "obj_scale";
            this.obj_scale.Size = new System.Drawing.Size(45, 20);
            this.obj_scale.TabIndex = 2;
            this.obj_scale.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // obj_rot
            // 
            this.obj_rot.Increment = new decimal(new int[] {
            45,
            0,
            0,
            0});
            this.obj_rot.Location = new System.Drawing.Point(51, 2);
            this.obj_rot.Maximum = new decimal(new int[] {
            315,
            0,
            0,
            0});
            this.obj_rot.Name = "obj_rot";
            this.obj_rot.Size = new System.Drawing.Size(45, 20);
            this.obj_rot.TabIndex = 2;
            this.obj_rot.ValueChanged += new System.EventHandler(this.obj_settings_ValueChanged);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(0, 27);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(34, 13);
            this.label3.TabIndex = 1;
            this.label3.Text = "Scale";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(0, 4);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 13);
            this.label2.TabIndex = 0;
            this.label2.Text = "Rotation";
            // 
            // obj_cats
            // 
            this.obj_cats.Controls.Add(this.obj_collection_buildings);
            this.obj_cats.Controls.Add(this.obj_collection_roads);
            this.obj_cats.Controls.Add(this.obj_collection_environment);
            this.obj_cats.Dock = System.Windows.Forms.DockStyle.Fill;
            this.obj_cats.Location = new System.Drawing.Point(0, 0);
            this.obj_cats.Name = "obj_cats";
            this.obj_cats.SelectedIndex = 0;
            this.obj_cats.Size = new System.Drawing.Size(217, 47);
            this.obj_cats.TabIndex = 0;
            this.obj_cats.SelectedIndexChanged += new System.EventHandler(this.obj_cats_SelectedIndexChanged);
            // 
            // obj_collection_buildings
            // 
            this.obj_collection_buildings.Location = new System.Drawing.Point(4, 22);
            this.obj_collection_buildings.Name = "obj_collection_buildings";
            this.obj_collection_buildings.Padding = new System.Windows.Forms.Padding(3);
            this.obj_collection_buildings.Size = new System.Drawing.Size(209, 21);
            this.obj_collection_buildings.TabIndex = 0;
            this.obj_collection_buildings.Text = "Buildings";
            this.obj_collection_buildings.UseVisualStyleBackColor = true;
            // 
            // obj_collection_roads
            // 
            this.obj_collection_roads.Location = new System.Drawing.Point(4, 22);
            this.obj_collection_roads.Name = "obj_collection_roads";
            this.obj_collection_roads.Padding = new System.Windows.Forms.Padding(3);
            this.obj_collection_roads.Size = new System.Drawing.Size(209, 21);
            this.obj_collection_roads.TabIndex = 1;
            this.obj_collection_roads.Text = "Roads";
            this.obj_collection_roads.UseVisualStyleBackColor = true;
            // 
            // obj_collection_environment
            // 
            this.obj_collection_environment.Location = new System.Drawing.Point(4, 22);
            this.obj_collection_environment.Name = "obj_collection_environment";
            this.obj_collection_environment.Size = new System.Drawing.Size(209, 21);
            this.obj_collection_environment.TabIndex = 2;
            this.obj_collection_environment.Text = "Environment";
            this.obj_collection_environment.UseVisualStyleBackColor = true;
            // 
            // physics_tab
            // 
            this.physics_tab.Location = new System.Drawing.Point(4, 22);
            this.physics_tab.Name = "physics_tab";
            this.physics_tab.Size = new System.Drawing.Size(223, 118);
            this.physics_tab.TabIndex = 2;
            this.physics_tab.Text = "Physics";
            this.physics_tab.UseVisualStyleBackColor = true;
            // 
            // nodes_tab
            // 
            this.nodes_tab.Location = new System.Drawing.Point(4, 22);
            this.nodes_tab.Name = "nodes_tab";
            this.nodes_tab.Size = new System.Drawing.Size(223, 118);
            this.nodes_tab.TabIndex = 3;
            this.nodes_tab.Text = "Nodes";
            this.nodes_tab.UseVisualStyleBackColor = true;
            // 
            // places_tab
            // 
            this.places_tab.Location = new System.Drawing.Point(4, 22);
            this.places_tab.Name = "places_tab";
            this.places_tab.Size = new System.Drawing.Size(223, 118);
            this.places_tab.TabIndex = 4;
            this.places_tab.Text = "Places";
            this.places_tab.UseVisualStyleBackColor = true;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(853, 398);
            this.Controls.Add(this.main_splitter);
            this.Name = "MainWindow";
            this.Text = "City Builder";
            this.main_splitter.Panel1.ResumeLayout(false);
            this.main_splitter.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.main_splitter)).EndInit();
            this.main_splitter.ResumeLayout(false);
            this.mapViewPanel_c.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.mapViewPanel)).EndInit();
            this.toolpanel_splitter.Panel1.ResumeLayout(false);
            this.toolpanel_splitter.Panel1.PerformLayout();
            this.toolpanel_splitter.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.toolpanel_splitter)).EndInit();
            this.toolpanel_splitter.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.minimap)).EndInit();
            this.tool_tabs.ResumeLayout(false);
            this.terrain_tab.ResumeLayout(false);
            this.terrain_tab.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.terrain_penSize)).EndInit();
            this.objects_tab.ResumeLayout(false);
            this.obj_splitter.Panel1.ResumeLayout(false);
            this.obj_splitter.Panel1.PerformLayout();
            this.obj_splitter.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.obj_splitter)).EndInit();
            this.obj_splitter.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.obj_scale)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.obj_rot)).EndInit();
            this.obj_cats.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer main_splitter;
        private System.Windows.Forms.Panel mapViewPanel_c;
        private System.Windows.Forms.SplitContainer toolpanel_splitter;
        internal System.Windows.Forms.CheckBox layer_ceiling;
        internal System.Windows.Forms.CheckBox layer_objects;
        internal System.Windows.Forms.CheckBox layer_floor;
        private System.Windows.Forms.TabControl tool_tabs;
        private System.Windows.Forms.TabPage terrain_tab;
        private System.Windows.Forms.TabPage objects_tab;
        private System.Windows.Forms.TabPage physics_tab;
        private System.Windows.Forms.Button colour_btn;
        private System.Windows.Forms.ColorDialog colorDialog1;
        private System.Windows.Forms.Button pen_btn;
        private System.Windows.Forms.Button texture_btn;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.NumericUpDown terrain_penSize;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.PictureBox mapViewPanel;
        private System.Windows.Forms.Button flush_textureCache;
        private System.Windows.Forms.SplitContainer obj_splitter;
        private System.Windows.Forms.NumericUpDown obj_scale;
        private System.Windows.Forms.NumericUpDown obj_rot;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckBox obj_flipY;
        private System.Windows.Forms.CheckBox obj_flipX;
        private System.Windows.Forms.TabPage nodes_tab;
        private System.Windows.Forms.TabPage places_tab;
        private System.Windows.Forms.TabControl obj_cats;
        private System.Windows.Forms.TabPage obj_collection_buildings;
        private System.Windows.Forms.TabPage obj_collection_roads;
        private System.Windows.Forms.TabPage obj_collection_environment;
        private System.Windows.Forms.PictureBox minimap;
        private System.Windows.Forms.Button terrain_shape_btn;
    }
}

