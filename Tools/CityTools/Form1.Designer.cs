﻿namespace CityTools
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
            this.components = new System.ComponentModel.Container();
            this.main_splitter = new System.Windows.Forms.SplitContainer();
            this.mapViewPanel_c = new System.Windows.Forms.Panel();
            this.mapViewPanel = new System.Windows.Forms.PictureBox();
            this.toolpanel_splitter = new System.Windows.Forms.SplitContainer();
            this.minimap = new System.Windows.Forms.PictureBox();
            this.minimap_context = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.minimapToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.redrawAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.first_level_tabControl = new System.Windows.Forms.TabControl();
            this.settings_tab = new System.Windows.Forms.TabPage();
            this.layer_objects_1 = new System.Windows.Forms.CheckBox();
            this.layer_nodes = new System.Windows.Forms.CheckBox();
            this.flush_textureCache = new System.Windows.Forms.Button();
            this.settings_lbl = new System.Windows.Forms.Label();
            this.layer_floor = new System.Windows.Forms.CheckBox();
            this.layer_physics = new System.Windows.Forms.CheckBox();
            this.layer_objects_0 = new System.Windows.Forms.CheckBox();
            this.tab_terrain_main = new System.Windows.Forms.TabPage();
            this.terrain_penSize = new System.Windows.Forms.TrackBar();
            this.texture_btn = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.terrain_shape_btn = new System.Windows.Forms.Button();
            this.pen_btn = new System.Windows.Forms.Button();
            this.colour_btn = new System.Windows.Forms.Button();
            this.palette_tab = new System.Windows.Forms.TabPage();
            this.tool_tabs = new System.Windows.Forms.TabControl();
            this.objects_tab = new System.Windows.Forms.TabPage();
            this.obj_splitter = new System.Windows.Forms.SplitContainer();
            this.obj_rot = new System.Windows.Forms.NumericUpDown();
            this.label2 = new System.Windows.Forms.Label();
            this.obj_scenary_objs = new System.Windows.Forms.Panel();
            this.obj_scenary_cache_CB = new System.Windows.Forms.ComboBox();
            this.physics_tab = new System.Windows.Forms.TabPage();
            this.phys_add_triangle = new System.Windows.Forms.Button();
            this.phys_add_ellipse = new System.Windows.Forms.Button();
            this.phys_add_rect = new System.Windows.Forms.Button();
            this.nodes_tab = new System.Windows.Forms.TabPage();
            this.places_tab = new System.Windows.Forms.TabPage();
            this.story_tab = new System.Windows.Forms.TabPage();
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
            this.minimap_context.SuspendLayout();
            this.first_level_tabControl.SuspendLayout();
            this.settings_tab.SuspendLayout();
            this.tab_terrain_main.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.terrain_penSize)).BeginInit();
            this.palette_tab.SuspendLayout();
            this.tool_tabs.SuspendLayout();
            this.objects_tab.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.obj_splitter)).BeginInit();
            this.obj_splitter.Panel1.SuspendLayout();
            this.obj_splitter.Panel2.SuspendLayout();
            this.obj_splitter.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.obj_rot)).BeginInit();
            this.physics_tab.SuspendLayout();
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
            this.main_splitter.Size = new System.Drawing.Size(853, 461);
            this.main_splitter.SplitterDistance = 618;
            this.main_splitter.TabIndex = 0;
            // 
            // mapViewPanel_c
            // 
            this.mapViewPanel_c.Controls.Add(this.mapViewPanel);
            this.mapViewPanel_c.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mapViewPanel_c.Location = new System.Drawing.Point(0, 0);
            this.mapViewPanel_c.Name = "mapViewPanel_c";
            this.mapViewPanel_c.Size = new System.Drawing.Size(618, 461);
            this.mapViewPanel_c.TabIndex = 0;
            // 
            // mapViewPanel
            // 
            this.mapViewPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mapViewPanel.Location = new System.Drawing.Point(0, 0);
            this.mapViewPanel.Name = "mapViewPanel";
            this.mapViewPanel.Size = new System.Drawing.Size(618, 461);
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
            // 
            // toolpanel_splitter.Panel2
            // 
            this.toolpanel_splitter.Panel2.Controls.Add(this.first_level_tabControl);
            this.toolpanel_splitter.Size = new System.Drawing.Size(231, 461);
            this.toolpanel_splitter.SplitterDistance = 231;
            this.toolpanel_splitter.TabIndex = 0;
            // 
            // minimap
            // 
            this.minimap.ContextMenuStrip = this.minimap_context;
            this.minimap.Location = new System.Drawing.Point(0, 0);
            this.minimap.Name = "minimap";
            this.minimap.Size = new System.Drawing.Size(231, 231);
            this.minimap.TabIndex = 3;
            this.minimap.TabStop = false;
            this.minimap.Paint += new System.Windows.Forms.PaintEventHandler(this.minimap_Paint);
            this.minimap.MouseClick += new System.Windows.Forms.MouseEventHandler(this.minimap_MouseClick);
            // 
            // minimap_context
            // 
            this.minimap_context.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.minimapToolStripMenuItem,
            this.redrawAllToolStripMenuItem});
            this.minimap_context.Name = "minimap_context";
            this.minimap_context.Size = new System.Drawing.Size(157, 48);
            // 
            // minimapToolStripMenuItem
            // 
            this.minimapToolStripMenuItem.Name = "minimapToolStripMenuItem";
            this.minimapToolStripMenuItem.Size = new System.Drawing.Size(156, 22);
            this.minimapToolStripMenuItem.Text = "Redraw Current";
            this.minimapToolStripMenuItem.Click += new System.EventHandler(this.minimapToolStripMenuItem_Click);
            // 
            // redrawAllToolStripMenuItem
            // 
            this.redrawAllToolStripMenuItem.Name = "redrawAllToolStripMenuItem";
            this.redrawAllToolStripMenuItem.Size = new System.Drawing.Size(156, 22);
            this.redrawAllToolStripMenuItem.Text = "Redraw All";
            this.redrawAllToolStripMenuItem.Click += new System.EventHandler(this.minimapToolStripMenuItem_Click);
            // 
            // first_level_tabControl
            // 
            this.first_level_tabControl.Controls.Add(this.settings_tab);
            this.first_level_tabControl.Controls.Add(this.tab_terrain_main);
            this.first_level_tabControl.Controls.Add(this.palette_tab);
            this.first_level_tabControl.Controls.Add(this.story_tab);
            this.first_level_tabControl.Dock = System.Windows.Forms.DockStyle.Fill;
            this.first_level_tabControl.Location = new System.Drawing.Point(0, 0);
            this.first_level_tabControl.Name = "first_level_tabControl";
            this.first_level_tabControl.SelectedIndex = 0;
            this.first_level_tabControl.Size = new System.Drawing.Size(231, 226);
            this.first_level_tabControl.TabIndex = 0;
            // 
            // settings_tab
            // 
            this.settings_tab.Controls.Add(this.layer_objects_1);
            this.settings_tab.Controls.Add(this.layer_nodes);
            this.settings_tab.Controls.Add(this.flush_textureCache);
            this.settings_tab.Controls.Add(this.settings_lbl);
            this.settings_tab.Controls.Add(this.layer_floor);
            this.settings_tab.Controls.Add(this.layer_physics);
            this.settings_tab.Controls.Add(this.layer_objects_0);
            this.settings_tab.Location = new System.Drawing.Point(4, 22);
            this.settings_tab.Name = "settings_tab";
            this.settings_tab.Padding = new System.Windows.Forms.Padding(3);
            this.settings_tab.Size = new System.Drawing.Size(223, 200);
            this.settings_tab.TabIndex = 0;
            this.settings_tab.Text = "Settings";
            this.settings_tab.UseVisualStyleBackColor = true;
            // 
            // layer_objects_1
            // 
            this.layer_objects_1.AutoSize = true;
            this.layer_objects_1.Checked = true;
            this.layer_objects_1.CheckState = System.Windows.Forms.CheckState.Checked;
            this.layer_objects_1.Location = new System.Drawing.Point(6, 69);
            this.layer_objects_1.Name = "layer_objects_1";
            this.layer_objects_1.Size = new System.Drawing.Size(94, 17);
            this.layer_objects_1.TabIndex = 15;
            this.layer_objects_1.Text = "Objects (Over)";
            this.layer_objects_1.UseVisualStyleBackColor = true;
            this.layer_objects_1.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // layer_nodes
            // 
            this.layer_nodes.AutoSize = true;
            this.layer_nodes.Location = new System.Drawing.Point(6, 115);
            this.layer_nodes.Name = "layer_nodes";
            this.layer_nodes.Size = new System.Drawing.Size(57, 17);
            this.layer_nodes.TabIndex = 14;
            this.layer_nodes.Text = "Nodes";
            this.layer_nodes.UseVisualStyleBackColor = true;
            this.layer_nodes.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // flush_textureCache
            // 
            this.flush_textureCache.Location = new System.Drawing.Point(112, 7);
            this.flush_textureCache.Name = "flush_textureCache";
            this.flush_textureCache.Size = new System.Drawing.Size(105, 23);
            this.flush_textureCache.TabIndex = 13;
            this.flush_textureCache.Text = "Flush";
            this.flush_textureCache.UseVisualStyleBackColor = true;
            this.flush_textureCache.Click += new System.EventHandler(this.flush_textureCache_Click);
            // 
            // settings_lbl
            // 
            this.settings_lbl.AutoSize = true;
            this.settings_lbl.Location = new System.Drawing.Point(7, 7);
            this.settings_lbl.Name = "settings_lbl";
            this.settings_lbl.Size = new System.Drawing.Size(74, 13);
            this.settings_lbl.TabIndex = 3;
            this.settings_lbl.Text = "Layer Controls";
            // 
            // layer_floor
            // 
            this.layer_floor.AutoSize = true;
            this.layer_floor.Checked = true;
            this.layer_floor.CheckState = System.Windows.Forms.CheckState.Checked;
            this.layer_floor.Location = new System.Drawing.Point(6, 23);
            this.layer_floor.Name = "layer_floor";
            this.layer_floor.Size = new System.Drawing.Size(49, 17);
            this.layer_floor.TabIndex = 0;
            this.layer_floor.Text = "Floor";
            this.layer_floor.UseVisualStyleBackColor = true;
            this.layer_floor.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // layer_physics
            // 
            this.layer_physics.AutoSize = true;
            this.layer_physics.Location = new System.Drawing.Point(6, 92);
            this.layer_physics.Name = "layer_physics";
            this.layer_physics.Size = new System.Drawing.Size(62, 17);
            this.layer_physics.TabIndex = 2;
            this.layer_physics.Text = "Physics";
            this.layer_physics.UseVisualStyleBackColor = true;
            this.layer_physics.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // layer_objects_0
            // 
            this.layer_objects_0.AutoSize = true;
            this.layer_objects_0.Checked = true;
            this.layer_objects_0.CheckState = System.Windows.Forms.CheckState.Checked;
            this.layer_objects_0.Location = new System.Drawing.Point(6, 46);
            this.layer_objects_0.Name = "layer_objects_0";
            this.layer_objects_0.Size = new System.Drawing.Size(100, 17);
            this.layer_objects_0.TabIndex = 1;
            this.layer_objects_0.Text = "Objects (Under)";
            this.layer_objects_0.UseVisualStyleBackColor = true;
            this.layer_objects_0.CheckedChanged += new System.EventHandler(this.layerSettingsChanged);
            // 
            // tab_terrain_main
            // 
            this.tab_terrain_main.Controls.Add(this.terrain_penSize);
            this.tab_terrain_main.Controls.Add(this.texture_btn);
            this.tab_terrain_main.Controls.Add(this.label1);
            this.tab_terrain_main.Controls.Add(this.terrain_shape_btn);
            this.tab_terrain_main.Controls.Add(this.pen_btn);
            this.tab_terrain_main.Controls.Add(this.colour_btn);
            this.tab_terrain_main.Location = new System.Drawing.Point(4, 22);
            this.tab_terrain_main.Name = "tab_terrain_main";
            this.tab_terrain_main.Size = new System.Drawing.Size(223, 200);
            this.tab_terrain_main.TabIndex = 2;
            this.tab_terrain_main.Text = "Terrain";
            this.tab_terrain_main.UseVisualStyleBackColor = true;
            // 
            // terrain_penSize
            // 
            this.terrain_penSize.LargeChange = 25;
            this.terrain_penSize.Location = new System.Drawing.Point(61, 66);
            this.terrain_penSize.Maximum = 1000;
            this.terrain_penSize.Minimum = 1;
            this.terrain_penSize.Name = "terrain_penSize";
            this.terrain_penSize.Size = new System.Drawing.Size(154, 45);
            this.terrain_penSize.TabIndex = 12;
            this.terrain_penSize.Value = 100;
            // 
            // texture_btn
            // 
            this.texture_btn.Location = new System.Drawing.Point(117, 33);
            this.texture_btn.Name = "texture_btn";
            this.texture_btn.Size = new System.Drawing.Size(98, 23);
            this.texture_btn.TabIndex = 11;
            this.texture_btn.Text = "Pick Texture";
            this.texture_btn.UseVisualStyleBackColor = true;
            this.texture_btn.Click += new System.EventHandler(this.terrain_texture_btn_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(3, 75);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 10;
            this.label1.Text = "Pen Size";
            // 
            // terrain_shape_btn
            // 
            this.terrain_shape_btn.Location = new System.Drawing.Point(117, 4);
            this.terrain_shape_btn.Name = "terrain_shape_btn";
            this.terrain_shape_btn.Size = new System.Drawing.Size(98, 23);
            this.terrain_shape_btn.TabIndex = 7;
            this.terrain_shape_btn.Text = "Shape (Circle)";
            this.terrain_shape_btn.UseVisualStyleBackColor = true;
            this.terrain_shape_btn.Click += new System.EventHandler(this.terrain_shape_btn_Click);
            // 
            // pen_btn
            // 
            this.pen_btn.Location = new System.Drawing.Point(6, 4);
            this.pen_btn.Name = "pen_btn";
            this.pen_btn.Size = new System.Drawing.Size(105, 23);
            this.pen_btn.TabIndex = 8;
            this.pen_btn.Text = "Pen Tool (Off)";
            this.pen_btn.UseVisualStyleBackColor = true;
            this.pen_btn.Click += new System.EventHandler(this.terrain_pen_Click);
            // 
            // colour_btn
            // 
            this.colour_btn.Location = new System.Drawing.Point(6, 33);
            this.colour_btn.Name = "colour_btn";
            this.colour_btn.Size = new System.Drawing.Size(105, 23);
            this.colour_btn.TabIndex = 6;
            this.colour_btn.Text = "Pick Colour";
            this.colour_btn.UseVisualStyleBackColor = true;
            this.colour_btn.Click += new System.EventHandler(this.terrain_colour_btn_Click);
            // 
            // palette_tab
            // 
            this.palette_tab.Controls.Add(this.tool_tabs);
            this.palette_tab.Location = new System.Drawing.Point(4, 22);
            this.palette_tab.Margin = new System.Windows.Forms.Padding(0);
            this.palette_tab.Name = "palette_tab";
            this.palette_tab.Size = new System.Drawing.Size(223, 200);
            this.palette_tab.TabIndex = 1;
            this.palette_tab.Text = "Objects";
            this.palette_tab.UseVisualStyleBackColor = true;
            // 
            // tool_tabs
            // 
            this.tool_tabs.Controls.Add(this.objects_tab);
            this.tool_tabs.Controls.Add(this.physics_tab);
            this.tool_tabs.Controls.Add(this.nodes_tab);
            this.tool_tabs.Controls.Add(this.places_tab);
            this.tool_tabs.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tool_tabs.Location = new System.Drawing.Point(0, 0);
            this.tool_tabs.Margin = new System.Windows.Forms.Padding(0);
            this.tool_tabs.Name = "tool_tabs";
            this.tool_tabs.SelectedIndex = 0;
            this.tool_tabs.Size = new System.Drawing.Size(223, 200);
            this.tool_tabs.TabIndex = 1;
            // 
            // objects_tab
            // 
            this.objects_tab.Controls.Add(this.obj_splitter);
            this.objects_tab.Location = new System.Drawing.Point(4, 22);
            this.objects_tab.Margin = new System.Windows.Forms.Padding(0);
            this.objects_tab.Name = "objects_tab";
            this.objects_tab.Size = new System.Drawing.Size(215, 174);
            this.objects_tab.TabIndex = 1;
            this.objects_tab.Text = "Scenary";
            this.objects_tab.UseVisualStyleBackColor = true;
            // 
            // obj_splitter
            // 
            this.obj_splitter.Dock = System.Windows.Forms.DockStyle.Fill;
            this.obj_splitter.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.obj_splitter.IsSplitterFixed = true;
            this.obj_splitter.Location = new System.Drawing.Point(0, 0);
            this.obj_splitter.Margin = new System.Windows.Forms.Padding(0);
            this.obj_splitter.Name = "obj_splitter";
            this.obj_splitter.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // obj_splitter.Panel1
            // 
            this.obj_splitter.Panel1.Controls.Add(this.obj_rot);
            this.obj_splitter.Panel1.Controls.Add(this.label2);
            // 
            // obj_splitter.Panel2
            // 
            this.obj_splitter.Panel2.Controls.Add(this.obj_scenary_objs);
            this.obj_splitter.Panel2.Controls.Add(this.obj_scenary_cache_CB);
            this.obj_splitter.Size = new System.Drawing.Size(215, 174);
            this.obj_splitter.SplitterDistance = 61;
            this.obj_splitter.TabIndex = 0;
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
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(0, 4);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 13);
            this.label2.TabIndex = 0;
            this.label2.Text = "Rotation";
            // 
            // obj_scenary_objs
            // 
            this.obj_scenary_objs.Dock = System.Windows.Forms.DockStyle.Fill;
            this.obj_scenary_objs.Location = new System.Drawing.Point(0, 21);
            this.obj_scenary_objs.Name = "obj_scenary_objs";
            this.obj_scenary_objs.Size = new System.Drawing.Size(215, 88);
            this.obj_scenary_objs.TabIndex = 1;
            // 
            // obj_scenary_cache_CB
            // 
            this.obj_scenary_cache_CB.Dock = System.Windows.Forms.DockStyle.Top;
            this.obj_scenary_cache_CB.FormattingEnabled = true;
            this.obj_scenary_cache_CB.Location = new System.Drawing.Point(0, 0);
            this.obj_scenary_cache_CB.Name = "obj_scenary_cache_CB";
            this.obj_scenary_cache_CB.Size = new System.Drawing.Size(215, 21);
            this.obj_scenary_cache_CB.TabIndex = 0;
            this.obj_scenary_cache_CB.SelectedIndexChanged += new System.EventHandler(this.obj_scenary_cache_CB_SelectionChangeCommitted);
            // 
            // physics_tab
            // 
            this.physics_tab.Controls.Add(this.phys_add_triangle);
            this.physics_tab.Controls.Add(this.phys_add_ellipse);
            this.physics_tab.Controls.Add(this.phys_add_rect);
            this.physics_tab.Location = new System.Drawing.Point(4, 22);
            this.physics_tab.Name = "physics_tab";
            this.physics_tab.Size = new System.Drawing.Size(215, 174);
            this.physics_tab.TabIndex = 2;
            this.physics_tab.Text = "Physics";
            this.physics_tab.UseVisualStyleBackColor = true;
            // 
            // phys_add_triangle
            // 
            this.phys_add_triangle.Location = new System.Drawing.Point(4, 64);
            this.phys_add_triangle.Name = "phys_add_triangle";
            this.phys_add_triangle.Size = new System.Drawing.Size(207, 23);
            this.phys_add_triangle.TabIndex = 2;
            this.phys_add_triangle.Text = "Draw Physics Triangle";
            this.phys_add_triangle.UseVisualStyleBackColor = true;
            this.phys_add_triangle.Click += new System.EventHandler(this.phys_add_shape);
            // 
            // phys_add_ellipse
            // 
            this.phys_add_ellipse.Location = new System.Drawing.Point(4, 34);
            this.phys_add_ellipse.Name = "phys_add_ellipse";
            this.phys_add_ellipse.Size = new System.Drawing.Size(207, 23);
            this.phys_add_ellipse.TabIndex = 1;
            this.phys_add_ellipse.Text = "Draw Physics Circle";
            this.phys_add_ellipse.UseVisualStyleBackColor = true;
            this.phys_add_ellipse.Click += new System.EventHandler(this.phys_add_shape);
            // 
            // phys_add_rect
            // 
            this.phys_add_rect.Location = new System.Drawing.Point(4, 4);
            this.phys_add_rect.Name = "phys_add_rect";
            this.phys_add_rect.Size = new System.Drawing.Size(207, 23);
            this.phys_add_rect.TabIndex = 0;
            this.phys_add_rect.Text = "Draw Physics Rectangle";
            this.phys_add_rect.UseVisualStyleBackColor = true;
            this.phys_add_rect.Click += new System.EventHandler(this.phys_add_shape);
            // 
            // nodes_tab
            // 
            this.nodes_tab.Location = new System.Drawing.Point(4, 22);
            this.nodes_tab.Name = "nodes_tab";
            this.nodes_tab.Size = new System.Drawing.Size(215, 174);
            this.nodes_tab.TabIndex = 3;
            this.nodes_tab.Text = "Nodes";
            this.nodes_tab.UseVisualStyleBackColor = true;
            // 
            // places_tab
            // 
            this.places_tab.Location = new System.Drawing.Point(4, 22);
            this.places_tab.Name = "places_tab";
            this.places_tab.Size = new System.Drawing.Size(215, 174);
            this.places_tab.TabIndex = 4;
            this.places_tab.Text = "Places";
            this.places_tab.UseVisualStyleBackColor = true;
            // 
            // story_tab
            // 
            this.story_tab.Location = new System.Drawing.Point(4, 22);
            this.story_tab.Name = "story_tab";
            this.story_tab.Size = new System.Drawing.Size(223, 200);
            this.story_tab.TabIndex = 3;
            this.story_tab.Text = "Story";
            this.story_tab.UseVisualStyleBackColor = true;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(853, 461);
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
            this.toolpanel_splitter.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.toolpanel_splitter)).EndInit();
            this.toolpanel_splitter.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.minimap)).EndInit();
            this.minimap_context.ResumeLayout(false);
            this.first_level_tabControl.ResumeLayout(false);
            this.settings_tab.ResumeLayout(false);
            this.settings_tab.PerformLayout();
            this.tab_terrain_main.ResumeLayout(false);
            this.tab_terrain_main.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.terrain_penSize)).EndInit();
            this.palette_tab.ResumeLayout(false);
            this.tool_tabs.ResumeLayout(false);
            this.objects_tab.ResumeLayout(false);
            this.obj_splitter.Panel1.ResumeLayout(false);
            this.obj_splitter.Panel1.PerformLayout();
            this.obj_splitter.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.obj_splitter)).EndInit();
            this.obj_splitter.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.obj_rot)).EndInit();
            this.physics_tab.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer main_splitter;
        private System.Windows.Forms.Panel mapViewPanel_c;
        private System.Windows.Forms.SplitContainer toolpanel_splitter;
        internal System.Windows.Forms.CheckBox layer_physics;
        internal System.Windows.Forms.CheckBox layer_objects_0;
        internal System.Windows.Forms.CheckBox layer_floor;
        private System.Windows.Forms.ColorDialog colorDialog1;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.PictureBox mapViewPanel;
        private System.Windows.Forms.PictureBox minimap;
        private System.Windows.Forms.ContextMenuStrip minimap_context;
        private System.Windows.Forms.ToolStripMenuItem minimapToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem redrawAllToolStripMenuItem;
        private System.Windows.Forms.TabControl first_level_tabControl;
        private System.Windows.Forms.TabPage settings_tab;
        private System.Windows.Forms.Label settings_lbl;
        private System.Windows.Forms.TabPage palette_tab;
        private System.Windows.Forms.TabControl tool_tabs;
        private System.Windows.Forms.TabPage objects_tab;
        private System.Windows.Forms.SplitContainer obj_splitter;
        internal System.Windows.Forms.NumericUpDown obj_rot;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TabPage physics_tab;
        private System.Windows.Forms.Button phys_add_triangle;
        private System.Windows.Forms.Button phys_add_ellipse;
        private System.Windows.Forms.Button phys_add_rect;
        private System.Windows.Forms.TabPage nodes_tab;
        private System.Windows.Forms.TabPage places_tab;
        private System.Windows.Forms.TabPage tab_terrain_main;
        private System.Windows.Forms.Button texture_btn;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button terrain_shape_btn;
        private System.Windows.Forms.Button pen_btn;
        private System.Windows.Forms.Button colour_btn;
        private System.Windows.Forms.TabPage story_tab;
        private System.Windows.Forms.Button flush_textureCache;
        internal System.Windows.Forms.TrackBar terrain_penSize;
        private System.Windows.Forms.ComboBox obj_scenary_cache_CB;
        private System.Windows.Forms.Panel obj_scenary_objs;
        internal System.Windows.Forms.CheckBox layer_objects_1;
        internal System.Windows.Forms.CheckBox layer_nodes;
    }
}

