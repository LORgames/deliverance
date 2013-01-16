using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using CityTools.Components;
using CityTools.ObjectSystem;
using CityTools.Terrain;
using CityTools.Core;
using CityTools.Nodes;

namespace CityTools {
    public enum PaintMode {
        Off,
        Terrain,
        Objects,
        Physics,
        ObjectSelector,
        Nodes,
        NodeLinks,
        NodeSelector
    }

    public partial class MainWindow : Form {
        public const string MAP_MINI_GROUND_CACHE = "minimap_ground.png";
        public const string MAP_MINI_OBJECT_CACHE = "minimap_object.png";

        public Color BACKGROUND_COLOR = Color.CornflowerBlue;

        public const int MAP_SIZE_X = 18688;
        public const int MAP_SIZE_Y = 18688;

        public static MainWindow instance;
        public bool REQUIRES_CLOSE = false;

        //Our drawing settings
        public Rectangle drawArea = new Rectangle();
        public PaintMode paintMode = PaintMode.Off;

        //Our drawing buffers
        public LBuffer floor_buffer;
        public LBuffer objects0_buffer;
        public LBuffer objects1_buffer;
        public LBuffer physics_buffer;
        public LBuffer nodes_buffer;
        public LBuffer input_buffer;

        public LBuffer mapBuffer_ground;
        public LBuffer mapBuffer_object;

        //Terrain painting things
        public Brush terrainPaintBrush = new SolidBrush(Color.White);

        //Object painting things
        public Bitmap obj_paint_image = null;
        public String obj_paint_original = "";
        public bool was_mouse_down = false;

        public bool initialized = false;

        public MainWindow() {
            instance = this;

            InitializeComponent();

            Box2D.B2System.Initialize();
            MapCache.VerifyCacheFiles();

            ScenicObjectCache.InitializeCache();
            //Nodes.NodeCache.InitializeCache();

            obj_scenary_objs.Controls.Add(new ObjectCacheControl("Road"));

            List<String> dark = new List<string>();
            dark.InsertRange(0, Directory.GetDirectories("objcache"));

            for(int i = 0; i < dark.Count; i++) {
                dark[i] = dark[i].Split('\\')[1];
            }

            obj_scenary_cache_CB.DataSource = dark;

            TerrainHelper.InitializeTerrainSystem(terrain_tilesCB, terrain_tilesPan);

            drawArea = mapViewPanel.DisplayRectangle;
            Camera.FixViewArea(drawArea);

            initialized = true;
            CreateBuffers();
        }

        private void CreateBuffers() {
            if (!initialized) return;

            drawArea = mapViewPanel.DisplayRectangle;

            floor_buffer = new LBuffer();
            objects0_buffer = new LBuffer();
            objects1_buffer = new LBuffer();
            physics_buffer = new LBuffer();
            nodes_buffer = new LBuffer();
            input_buffer = new LBuffer();
            Physics.PhysicsDrawer.physicsBuffer = new LBuffer();

            TerrainHelper.DrawTerrain(floor_buffer);
            mapViewPanel.Invalidate();
        }

        private void mapViewPanel_Paint(object sender, PaintEventArgs e) {
            if (!initialized) return;
            if (REQUIRES_CLOSE) { this.Close(); return; }

            drawArea = e.ClipRectangle;
            e.Graphics.FillRectangle(new SolidBrush(BACKGROUND_COLOR), e.ClipRectangle);

            RedrawTerrain();

            if (layer_floor.Checked) e.Graphics.DrawImage(floor_buffer.bmp, Point.Empty);
            if (layer_objects_0.Checked) e.Graphics.DrawImage(objects0_buffer.bmp, Point.Empty);
            if (layer_objects_1.Checked) e.Graphics.DrawImage(objects1_buffer.bmp, Point.Empty);
            if (layer_physics.Checked) e.Graphics.DrawImage(physics_buffer.bmp, Point.Empty);
            if (layer_nodes.Checked) e.Graphics.DrawImage(nodes_buffer.bmp, Point.Empty);

            if (paintMode != PaintMode.Off) e.Graphics.DrawImage(input_buffer.bmp, Point.Empty);
        }

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData) {
            if (Camera.ProcessKeys(keyData)) {
                Camera.FixViewArea(drawArea);

                TerrainHelper.DrawTerrain(floor_buffer);

                mapViewPanel.Invalidate();
                minimap.Invalidate();
            } else if (keyData == Keys.Escape) {
                input_buffer.gfx.Clear(Color.Transparent);
                mapViewPanel.Invalidate();
            } else if (keyData == Keys.R) {
                if (obj_rot.Value < 315) {
                    obj_rot.Value += 45;
                } else {
                    obj_rot.Value = 0;
                }
            } else if (keyData == Keys.F) {
                if (obj_rot.Value > 0) {
                    obj_rot.Value -= 45;
                } else {
                    obj_rot.Value = 315;
                }
            } else if (paintMode == PaintMode.ObjectSelector) {
                // Pass the data onto the helper
                ScenicHelper.ProcessCmdKey(ref msg, keyData);

                // Get the window to redraw
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.NodeSelector) {
                NodeHelper.ProcessCmdKey(ref msg, keyData);

                // Get the window to redraw
                mapViewPanel.Invalidate();
            }

            return base.ProcessCmdKey(ref msg, keyData);
        }

        private void layerSettingsChanged(object sender, EventArgs e) {
            mapViewPanel.Invalidate();
            minimap.Invalidate();
        }

        private void drawPanel_ME_up(object sender, MouseEventArgs e) {
            if (paintMode == PaintMode.Physics) {
                Physics.PhysicsDrawer.ReleaseMouse(e);
                input_buffer.gfx.Clear(Color.Transparent);
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.ObjectSelector) {
                input_buffer.gfx.Clear(Color.Transparent);
                mapViewPanel.Invalidate();
                ScenicHelper.MouseUp(e);
            } else if (paintMode == PaintMode.Objects) {
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.Terrain) {
                MapCache.SaveMap();
            } else if (paintMode == PaintMode.Nodes) {
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.NodeLinks) {
                input_buffer.gfx.Clear(Color.Transparent);
                mapViewPanel.Invalidate();
                NodeHelper.MouseUp(e);
            } else if (paintMode == PaintMode.NodeSelector) {
                input_buffer.gfx.Clear(Color.Transparent);
                mapViewPanel.Invalidate();
                NodeHelper.MouseUp_Selector(e);
            }

            was_mouse_down = false;
        }

        private void drawPanel_ME_move(object sender, MouseEventArgs e) {
            mapViewPanel.Focus();
            
            if (paintMode == PaintMode.Terrain) {
                if (TerrainHelper.MouseMoveOrDown(e, input_buffer)) {
                    TerrainHelper.DrawTerrain(floor_buffer);
                }
            } else if(paintMode == PaintMode.Objects) {
                if(ObjectSystem.ScenicPlacementHelper.UpdateMouse(e, input_buffer)) {
                    ScenicDrawer.DrawScenicObjects(objects0_buffer);
                }
            } else if (paintMode == PaintMode.Physics) {
                Physics.PhysicsDrawer.UpdateMouse(e, input_buffer);
            } else if (paintMode == PaintMode.ObjectSelector) {
                ScenicHelper.UpdateMouse(e, input_buffer);
            } else if (paintMode == PaintMode.Nodes) {
            } else if (paintMode == PaintMode.NodeLinks) {
                if (NodeHelper.UpdateMouse(e, input_buffer)) {
                    //mapViewPanel.Invalidate();
                }
            } else if (paintMode == PaintMode.NodeSelector) {
                //mapViewPanel.Invalidate();
                NodeHelper.UpdateMouse_Selector(e, input_buffer);
            }

            mapViewPanel.Invalidate();
        }

        private void drawPanel_ME_down(object sender, MouseEventArgs e) {
            if (paintMode == PaintMode.Terrain) {
                if (TerrainHelper.MouseMoveOrDown(e, input_buffer)) {
                    TerrainHelper.DrawTerrain(floor_buffer);
                }
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.Objects) {
                ObjectSystem.ScenicPlacementHelper.MouseDown(e, input_buffer);
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.Physics) {
                Physics.PhysicsDrawer.MouseDown(e, input_buffer);
            } else if (paintMode == PaintMode.ObjectSelector) {
                ScenicHelper.MouseDown(e);
            } else if (paintMode == PaintMode.Nodes) {
                Nodes.NodeDrawer.MouseDown(e, input_buffer);
                mapViewPanel.Invalidate();
            } else if (paintMode == PaintMode.NodeLinks) {
                NodeHelper.MouseDown(e);
            } else if (paintMode == PaintMode.NodeSelector) {
                NodeHelper.MouseDown_Selector(e);
            }
        }

        private void RedrawTerrain() {
            if (!initialized) return;

            floor_buffer.gfx.Clear(Color.Transparent);
            objects0_buffer.gfx.Clear(Color.Transparent);
            objects1_buffer.gfx.Clear(Color.Transparent);
            physics_buffer.gfx.Clear(Color.Transparent);
            nodes_buffer.gfx.Clear(Color.Transparent);

            if (layer_objects_0.Checked) {
                ScenicDrawer.DrawScenicObjects(objects0_buffer);
            }

            if (layer_nodes.Checked) {
                NodeDrawer.DrawNodes(nodes_buffer);
            }
                
            if (layer_floor.Checked) {
                TerrainHelper.DrawTerrain(floor_buffer);
            }
        }

        private void mapViewPanel_Resize(object sender, EventArgs e) {
            if (!initialized) return;

            drawArea = mapViewPanel.DisplayRectangle;
            Camera.FixViewArea(drawArea);
            CreateBuffers();

            Terrain.TerrainHelper.DrawTerrain(floor_buffer);
            ScenicDrawer.DrawScenicObjects(objects0_buffer);
            mapViewPanel.Invalidate();

            minimap.Invalidate();
        }

        private bool DRAWN = false;
        private void minimap_Paint(object sender, PaintEventArgs e) {
            if (!initialized) return;

            if (REQUIRES_CLOSE) { this.Close(); return; }

            float scaleX = (float)minimap.Width / MAP_SIZE_X;
            float scaleY = (float)minimap.Height / MAP_SIZE_Y;

            if (!DRAWN) {
                mapBuffer_ground = new LBuffer(minimap.DisplayRectangle);
                Minimap.MinimapDrawer.RedrawAllTerrain(mapBuffer_ground, minimap.DisplayRectangle);
                DRAWN = true;
            }

            e.Graphics.DrawImage(mapBuffer_ground.bmp, Point.Empty);
            e.Graphics.DrawRectangle(new Pen(Color.Red), Camera.Offset.X * scaleX, Camera.Offset.Y * scaleY, Camera.ViewArea.Width * scaleX, Camera.ViewArea.Height * scaleY);
        }

        private void minimap_MouseClick(object sender, MouseEventArgs e) {
            //Need to pan there :)
            Camera.Offset.X = (e.Location.X / (float)minimap.Width) * MAP_SIZE_X;
            Camera.Offset.Y = (e.Location.Y / (float)minimap.Height) * MAP_SIZE_Y;

            Camera.FixViewArea(drawArea);

            TerrainHelper.DrawTerrain(floor_buffer);
            ScenicDrawer.DrawScenicObjects(objects0_buffer);

            mapViewPanel.Invalidate();
            minimap.Invalidate();
        }

        public void DrawWithObject(String objectName) {
            if (first_level_tabControl.SelectedTab == terrain_tab) {
                paintMode = PaintMode.Terrain;
                TerrainHelper.SetCurrentTile(TerrainHelper.StripTileIDFromPath(objectName));
            } else if (first_level_tabControl.SelectedTab == palette_tab) {
                CityTools.ObjectSystem.ScenicPlacementHelper.object_index = ScenicObjectCache.s_StringToInt[objectName];//objectName;
                paintMode = PaintMode.Objects;
                obj_paint_original = objectName;
                obj_paint_image = (Bitmap)ImageCache.RequestImage(objectName, (int)obj_rot.Value);
            }
        }

        private void obj_settings_ValueChanged(object sender, EventArgs e) {
            if (obj_paint_original != null) {
                obj_paint_image = (Bitmap)ImageCache.RequestImage(obj_paint_original, (int)obj_rot.Value);
                drawPanel_ME_move(null, new MouseEventArgs(System.Windows.Forms.MouseButtons.None, 0, 0, 0, 0));
            }
        }

        private void phys_add_shape(object sender, EventArgs e) {
            paintMode = PaintMode.Physics;
            Physics.PhysicsDrawer.SetShape(((Button)sender).Name);
        }

        private void obj_select_btn_Click(object sender, EventArgs e) {
            paintMode = PaintMode.ObjectSelector;
            mapViewPanel.Cursor = Cursors.Cross;
        }

        private void MainWindow_FormClosing(object sender, FormClosingEventArgs e) {
            ScenicObjectCache.SaveTypes();
            ScenicObjectCache.SaveCache();

            try {
                mapBuffer_ground.bmp.Save("minimap.jpg");
            } catch {
                try {
                    File.Delete("minimap.jpg");
                } catch {
                    //MessageBox.Show("There was a critical exception handled and magic wasn't able to fix it either. Now you can be the hero of the story and slay the beast.\n\nPlease delete minimap.png");
                }
            }
        }

        private void terrain_tilesCB_SelectedIndexChanged(object sender, EventArgs e) {
            (terrain_tilesPan.Controls[0] as ObjectCacheControl).Activate(terrain_tilesCB.SelectedValue.ToString());
        }

        private void obj_scenary_cache_CB_SelectionChangeCommitted(object sender, EventArgs e) {
            (obj_scenary_objs.Controls[0] as ObjectCacheControl).Activate(obj_scenary_cache_CB.SelectedValue.ToString());
        }

        private void tsmSendBack_Click(object sender, EventArgs e) {
            ScenicHelper.SendBack();

            // Get the window to redraw
            mapViewPanel.Invalidate();
        }

        private void tsmBringForward_Click(object sender, EventArgs e) {
            ScenicHelper.BringForward();

            // Get the window to redraw
            mapViewPanel.Invalidate();
        }

        private void tsmSendToBack_Click(object sender, EventArgs e) {
            ScenicHelper.SendToBack();

            // Get the window to redraw
            mapViewPanel.Invalidate();
        }

        private void tsmBringToFront_Click(object sender, EventArgs e) {
            ScenicHelper.BringToFront();

            // Get the window to redraw
            mapViewPanel.Invalidate();
        }

        private void node_add_node_Click(object sender, EventArgs e) {
            paintMode = PaintMode.Nodes;
        }

        private void node_add_node_link_Click(object sender, EventArgs e) {
            paintMode = PaintMode.NodeLinks;
        }

        private void node_select_btn_Click(object sender, EventArgs e) {
            paintMode = PaintMode.NodeSelector;
        }
    }
}
