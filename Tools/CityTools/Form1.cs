using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using CityTools.components;

namespace CityTools {
    public enum PaintMode {
        Off,
        Terrain,
        Objects
    }

    public enum PaintLayers {
        Ground,
        Objects,
        Ceiling
    }

    public enum PaintShape {
        Circle,
        Square
    }

    public partial class MainWindow : Form {
        public const int TILE_SX = 1024; //The width of a single image block
        public const int TILE_SY = 1024; //The height of a single image block

        public const int TILE_TX = 16; //How many image blocks across
        public const int TILE_TY = 16; //How many image blocks down

        public const string MAP_MINI_GROUND_CACHE = "minimap_ground.png";
        public const string MAP_MINI_OBJECT_CACHE = "minimap_object.png";

        public Color BACKGROUND_COLOR = Color.CornflowerBlue;

        private float offsetX = 0.0f;
        private float offsetY = 0.0f;
        private float offsetZ = 1.0f;

        public static MainWindow instance;
        public bool REQUIRES_CLOSE = false;

        //Our cache
        public Boolean[,] needsToBeSaved;
        public Image[,] base_images;
        public Image[,] top_images;
        public Image[,] object_images;

        //Our drawing settings
        public Rectangle drawArea = new Rectangle();
        public Rectangle viewArea = new Rectangle();

        public Rectangle cachedMapArea = new Rectangle();

        public Point mousePos = Point.Empty;
        public Point snapPoint = Point.Empty;
        public PaintMode paintMode = PaintMode.Off;
        public PaintLayers activeLayer = PaintLayers.Ground;

        //Our drawing buffers
        public LBuffer floor_buffer;
        public LBuffer ceiling_buffer;
        public LBuffer objects_buffer;
        public LBuffer input_buffer;

        public LBuffer mapBuffer_ground;
        public LBuffer mapBuffer_object;

        //Terrain painting things
        public bool terrainRedrawRequired = true;
        public Brush terrainPaintBrush = new SolidBrush(Color.White);
        public PaintShape paintShape = PaintShape.Circle;

        //Object painting things
        public Bitmap obj_paint_image = null;
        public Image obj_paint_original = null;
        public bool was_mouse_down = false;

        public MainWindow() {
            instance = this;

            InitializeComponent();

            obj_collection_buildings.Controls.Add(new ObjectCacheControl("buildings"));
            obj_collection_roads.Controls.Add(new ObjectCacheControl("roads"));
            obj_collection_environment.Controls.Add(new ObjectCacheControl("environment"));

            needsToBeSaved = new Boolean[TILE_TX, TILE_TY];
            base_images = new Image[TILE_TX, TILE_TY];
            top_images = new Image[TILE_TX, TILE_TY];
            object_images = new Image[TILE_TX, TILE_TY];

            MapCache.VerifyCacheFiles();

            MapCache.Fetchmap(0, 0, 1, 1, ref cachedMapArea);

            drawArea = mapViewPanel.DisplayRectangle;
            FixViewArea();
            CreateBuffers();
        }

        private void CreateBuffers() {
            drawArea = mapViewPanel.DisplayRectangle;

            floor_buffer = new LBuffer();
            objects_buffer = new LBuffer();
            ceiling_buffer = new LBuffer();
            input_buffer = new LBuffer();

            terrainRedrawRequired = true;
            mapViewPanel.Invalidate();
        }

        private void mapViewPanel_Paint(object sender, PaintEventArgs e) {
            if (REQUIRES_CLOSE) { this.Close(); return; }

            drawArea = e.ClipRectangle;
            e.Graphics.FillRectangle(new SolidBrush(BACKGROUND_COLOR), e.ClipRectangle);

            RedrawTerrain();

            if (layer_floor.Checked) e.Graphics.DrawImage(floor_buffer.bmp, Point.Empty);
            if (layer_objects.Checked) e.Graphics.DrawImage(objects_buffer.bmp, Point.Empty);
            if (layer_ceiling.Checked) e.Graphics.DrawImage(ceiling_buffer.bmp, Point.Empty);
            if (paintMode != PaintMode.Off) e.Graphics.DrawImage(input_buffer.bmp, Point.Empty);
        }

        protected override bool ProcessCmdKey(ref Message msg, Keys keyData) {
            if (keyData == Keys.W || keyData == Keys.A || keyData == Keys.S || keyData == Keys.D || keyData == Keys.Q || keyData == Keys.E) {
                if (keyData == Keys.W) {
                    offsetY -= 0.25f / offsetZ;
                } else if (keyData == Keys.A) {
                    offsetX -= 0.25f / offsetZ;
                } else if (keyData == Keys.S) {
                    offsetY += 0.25f / offsetZ;
                } else if (keyData == Keys.D) {
                    offsetX += 0.25f / offsetZ;
                } else if (keyData == Keys.Q) {
                    offsetZ *= 0.98f;
                } else if (keyData == Keys.E) {
                    offsetZ *= 1.02f;
                }

                if (offsetX < 0.0f) offsetX = 0.0f;
                if (offsetX > TILE_TX) offsetX = TILE_TX;

                if (offsetY < 0.0f) offsetY = 0.0f;
                if (offsetY > TILE_TY) offsetY = TILE_TY;

                if (offsetZ < 0.01f) offsetZ = 0.01f;
                if (offsetZ > 1.0f) offsetZ = 1.0f;

                FixViewArea();

                mapViewPanel.Invalidate();
                minimap.Invalidate();

                terrainRedrawRequired = true;

                return true;
            } else if (keyData == Keys.Escape) {
                paintMode = PaintMode.Off;
                pen_btn.Text = "Pen Tool (Off)";
                mapViewPanel.Invalidate();
            } else if (keyData == Keys.Left) {
                if (obj_rot.Value < 315) {
                    obj_rot.Value += 45;
                } else {
                    obj_rot.Value = 0;
                }
            } else if (keyData == Keys.Right) {
                if (obj_rot.Value > 0) {
                    obj_rot.Value -= 45;
                } else {
                    obj_rot.Value = 315;
                }
            }

            return base.ProcessCmdKey(ref msg, keyData);
        }

        private void FixViewArea() {
            viewArea = new Rectangle((int)(offsetX * TILE_SX), (int)(offsetY * TILE_SY), (int)(drawArea.Width / offsetZ), (int)(drawArea.Height / offsetZ));
        }

        private void layerSettingsChanged(object sender, EventArgs e) {
            mapViewPanel.Invalidate();
            minimap.Invalidate();
        }

        private void colour_btn_Click(object sender, EventArgs e) {
            if (colorDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK) {
                terrainPaintBrush = new SolidBrush(colorDialog1.Color);
            }
        }

        private void texture_btn_Click(object sender, EventArgs e) {
            openFileDialog1.Filter = "Images|*.jpg;*.png;*.bmp";

            if (openFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK) {
                terrainPaintBrush = new TextureBrush(new Bitmap(openFileDialog1.FileName));
            }
        }

        private void drawPanel_ME_up(object sender, MouseEventArgs e) {
            if (paintMode != PaintMode.Off) {
                outputCurrentCachedMapToFile();
            }

            was_mouse_down = false;
        }

        private void outputCurrentCachedMapToFile() {
            MapCache.outputCurrentCachedMapToFile(cachedMapArea);

            PartiallyRedrawMinimap(cachedMapArea);
        }

        private void drawPanel_ME_move(object sender, MouseEventArgs e) {
            mapViewPanel.Focus();
            mousePos = e.Location;

            if (paintMode == PaintMode.Terrain) {
                Rectangle effectedArea = new Rectangle((int)(mousePos.X - terrain_penSize.Value / 2), (int)(mousePos.Y - terrain_penSize.Value / 2), (int)terrain_penSize.Value, (int)terrain_penSize.Value);
                
                input_buffer.gfx.Clear(Color.Transparent);

                if (paintShape == PaintShape.Square) {
                    input_buffer.gfx.FillRectangle(terrainPaintBrush, effectedArea);
                } else if (paintShape == PaintShape.Circle) {
                    input_buffer.gfx.FillEllipse(terrainPaintBrush, effectedArea);
                }

                if (e.Button == System.Windows.Forms.MouseButtons.Left) {
                    int oTileX, oTileY, wTileX, hTileY;

                    float scaledTileSizeX = TILE_SX * offsetZ;
                    float scaledTileSizeY = TILE_SY * offsetZ;

                    oTileX = (int)Math.Floor((effectedArea.Left / scaledTileSizeX) + offsetX);
                    oTileY = (int)Math.Floor((effectedArea.Top / scaledTileSizeY) + offsetY);
                    wTileX = (int)Math.Floor((effectedArea.Right / scaledTileSizeX) + offsetX);
                    hTileY = (int)Math.Floor((effectedArea.Bottom / scaledTileSizeY) + offsetY);

                    if (oTileX < 0) oTileX = 0;
                    if (oTileY < 0) oTileY = 0;
                    if (wTileX > TILE_TX) wTileX = TILE_TX;
                    if (hTileY > TILE_TY) hTileY = TILE_TY;

                    for (int i = oTileX; i <= wTileX; i++) {
                        for (int j = oTileY; j <= hTileY; j++) {
                            needsToBeSaved[i, j] = true;

                            float tX = ((effectedArea.Left / scaledTileSizeX) + offsetX - i) * TILE_SX;
                            float tY = ((effectedArea.Top / scaledTileSizeY) + offsetY - j) * TILE_SY;
                            float bX = ((effectedArea.Right / scaledTileSizeX) + offsetX - i) * TILE_SX;
                            float bY = ((effectedArea.Bottom / scaledTileSizeY) + offsetY - j) * TILE_SY;

                            Rectangle relativeRect = new Rectangle((int)tX, (int)tY, (int)(bX - tX), (int)(bY - tY));

                            try {
                                Graphics gfx = Graphics.FromImage(base_images[i, j]);
                                gfx.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
                                gfx.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                                gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

                                if (paintShape == PaintShape.Square) {
                                    gfx.FillRectangle(terrainPaintBrush, relativeRect);
                                } else if (paintShape == PaintShape.Circle) {
                                    gfx.FillEllipse(terrainPaintBrush, relativeRect);
                                }

                                gfx.Dispose();
                            } catch {

                            }
                        }
                    }

                    terrainRedrawRequired = true;
                }

                mapViewPanel.Invalidate();
            } else if(paintMode == PaintMode.Objects) {
                RectangleF effectedArea = new RectangleF(mousePos.X - (obj_paint_image.Width * offsetZ / 2), mousePos.Y - (obj_paint_image.Height * offsetZ / 2), obj_paint_image.Width * offsetZ, obj_paint_image.Height * offsetZ);

                Rectangle eD = new Rectangle((int)effectedArea.Left, (int)effectedArea.Top, (int)Math.Round(effectedArea.Width), (int)Math.Round(effectedArea.Height));

                input_buffer.gfx.Clear(Color.Transparent);
                input_buffer.gfx.DrawImage(obj_paint_image, eD);
                
                if (e.Button == System.Windows.Forms.MouseButtons.Left && !was_mouse_down) {
                    was_mouse_down = true;

                    int oTileX, oTileY, wTileX, hTileY;

                    RectangleF effectedCells = new RectangleF(effectedArea.Left / TILE_SX, effectedArea.Top / TILE_SY, 1 + effectedArea.Width / TILE_SX, 1 + effectedArea.Height / TILE_SY);

                    effectedCells.Offset(offsetX, offsetY);

                    oTileX = (int)effectedCells.Left;
                    oTileY = (int)effectedCells.Top;
                    wTileX = (int)Math.Ceiling(effectedCells.Right);
                    hTileY = (int)Math.Ceiling(effectedCells.Bottom);

                    if (oTileX < 0) oTileX = 0;
                    if (oTileY < 0) oTileY = 0;
                    if (wTileX > TILE_TX) wTileX = TILE_TX;
                    if (hTileY > TILE_TY) hTileY = TILE_TY;

                    for (int i = oTileX; i <= wTileX; i++) {
                        for (int j = oTileY; j <= hTileY; j++) {
                            needsToBeSaved[i, j] = true;

                            float tX = effectedArea.Left + TILE_SX * (offsetX - i);
                            float tY = effectedArea.Top + TILE_SY * (offsetY - j);
                            float bX = effectedArea.Right + TILE_SX * (offsetX - i);
                            float bY = effectedArea.Bottom + TILE_SY * (offsetY - j);

                            Rectangle relativeRect = new Rectangle((int)Math.Round(tX), (int)Math.Round(tY), obj_paint_image.Width, obj_paint_image.Height);

                            try {
                                Graphics gfx = Graphics.FromImage(object_images[i, j]);
                                gfx.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
                                gfx.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                                gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;

                                gfx.DrawImage(obj_paint_image, relativeRect);

                                gfx.Dispose();
                            } catch {

                            }
                        }
                    }

                    terrainRedrawRequired = true;
                }

                mapViewPanel.Invalidate();
            }
        }

        private void RedrawTerrain() {
            if (terrainRedrawRequired) {
                bool drawFloor = layer_floor.Checked;
                bool drawObjects = layer_objects.Checked;
                bool drawCeiling = layer_ceiling.Checked;

                if (!drawFloor && !drawObjects && !drawCeiling) {
                    return;
                }

                int oTileX, oTileY, wTileX, hTileY;

                float scaledTileSizeX = TILE_SX * offsetZ;
                float scaledTileSizeY = TILE_SY * offsetZ;

                oTileX = (int)Math.Floor((drawArea.Left / scaledTileSizeX) + offsetX);
                oTileY = (int)Math.Floor((drawArea.Top / scaledTileSizeY) + offsetY);
                wTileX = (int)Math.Floor((drawArea.Right / scaledTileSizeX) + offsetX);
                hTileY = (int)Math.Floor((drawArea.Bottom / scaledTileSizeY) + offsetY);

                if (oTileX < 0) oTileX = 0;
                if (oTileY < 0) oTileY = 0;
                if (wTileX > TILE_TX) wTileX = TILE_TX;
                if (hTileY > TILE_TY) hTileY = TILE_TY;

                MapCache.Fetchmap(oTileX, oTileY, wTileX, hTileY, ref cachedMapArea);

                float tileXPos = 0.0f;
                float tileYPos = 0.0f;

                floor_buffer.gfx.Clear(Color.Transparent);
                objects_buffer.gfx.Clear(Color.Transparent);
                ceiling_buffer.gfx.Clear(Color.Transparent);

                for (int i = oTileX; i <= wTileX; i++) {

                    tileXPos = drawArea.Left + ((i - offsetX) * scaledTileSizeX);

                    for (int j = oTileY; j <= hTileY; j++) {
                        tileYPos = drawArea.Top + ((j - offsetY) * scaledTileSizeY);

                        try {
                            if (drawFloor) {
                                floor_buffer.gfx.DrawImage(base_images[i, j], tileXPos, tileYPos, scaledTileSizeX, scaledTileSizeY);
                            }

                            if (drawObjects) {
                                objects_buffer.gfx.DrawImage(object_images[i, j], tileXPos, tileYPos, scaledTileSizeX, scaledTileSizeY);
                            }

                            if (drawCeiling) {
                                ceiling_buffer.gfx.DrawImage(top_images[i, j], tileXPos, tileYPos, scaledTileSizeX, scaledTileSizeY);
                            }
                        } catch {

                        }
                    }
                }
            }

            terrainRedrawRequired = false;
        }

        private void mapViewPanel_Resize(object sender, EventArgs e) {
            FixViewArea();
            CreateBuffers();
            minimap.Invalidate();
        }

        private void pen_btn_Click(object sender, EventArgs e) {
            if (paintMode == PaintMode.Terrain) {
                paintMode = PaintMode.Off;
                pen_btn.Text = "Pen Tool (Off)";
            } else {
                paintMode = PaintMode.Terrain;
                pen_btn.Text = "Pen Tool (On)";
                activeLayer = PaintLayers.Ground;
            }
        }

        private void flush_textureCache_Click(object sender, EventArgs e) {
            cachedMapArea = Rectangle.Empty;
            terrainRedrawRequired = true;
            mapViewPanel.Invalidate();
        }

        private void obj_cats_SelectedIndexChanged(object sender, EventArgs e) {
            ((ObjectCacheControl)obj_cats.SelectedTab.Controls[0]).Activate();
        }

        private void DrawInitialFullMap() {
            float scaleX = minimap.Width / (float)(TILE_SX * TILE_TX);
            float scaleY = minimap.Height / (float)(TILE_SY * TILE_TY);

            mapBuffer_ground = new LBuffer(new Rectangle(Point.Empty, minimap.Size));
            mapBuffer_object = new LBuffer(new Rectangle(Point.Empty, minimap.Size));

            if (File.Exists(MAP_MINI_GROUND_CACHE) && File.Exists(MAP_MINI_OBJECT_CACHE)) {
                mapBuffer_ground.gfx.DrawImage(Image.FromFile(MAP_MINI_GROUND_CACHE), Point.Empty);
                mapBuffer_object.gfx.DrawImage(Image.FromFile(MAP_MINI_OBJECT_CACHE), Point.Empty);
            } else {
                mapBuffer_ground.gfx.Clear(Color.Transparent);
                mapBuffer_object.gfx.Clear(Color.Transparent);

                Image currentMapChunk = null;

                for (int i = 0; i < TILE_TX; i++) {
                    for (int j = 0; j < TILE_TY; j++) {
                        currentMapChunk = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Ground));
                        mapBuffer_ground.gfx.DrawImage(currentMapChunk, new Rectangle((int)(i * TILE_SX * scaleX), (int)(j * TILE_SY * scaleY), (int)(TILE_SX * scaleX), (int)(TILE_SY * scaleY)));
                        currentMapChunk.Dispose();

                        currentMapChunk = Image.FromFile(MapCache.GetTileFilename(i, j, PaintLayers.Objects));
                        mapBuffer_object.gfx.DrawImage(currentMapChunk, new Rectangle((int)(i * TILE_SX * scaleX), (int)(j * TILE_SY * scaleY), (int)(TILE_SX * scaleX), (int)(TILE_SY * scaleY)));
                        currentMapChunk.Dispose();
                    }
                }

                mapBuffer_ground.bmp.Save(MAP_MINI_GROUND_CACHE);
                mapBuffer_object.bmp.Save(MAP_MINI_OBJECT_CACHE);
            }
        }

        private void PartiallyRedrawMinimap(Rectangle redrawArea) {
            float scaleX = minimap.Width / (float)(TILE_SX * TILE_TX);
            float scaleY = minimap.Height / (float)(TILE_SY * TILE_TY);

            Image currentMapChunk = null;

            for (int i = redrawArea.Left; i <= redrawArea.Right; i++) {
                for (int j = redrawArea.Top; j <= redrawArea.Bottom; j++) {
                    mapBuffer_object.gfx.FillRectangle(new SolidBrush(Color.Transparent), new Rectangle((int)(i * TILE_SX * scaleX), (int)(j * TILE_SY * scaleY), (int)(TILE_SX * scaleX), (int)(TILE_SY * scaleY)));

                    currentMapChunk = Image.FromFile(MapCache.GetTileFilename(i, j, activeLayer));
                    mapBuffer_object.gfx.DrawImage(currentMapChunk, new Rectangle((int)(i * TILE_SX * scaleX), (int)(j * TILE_SY * scaleY), (int)(TILE_SX * scaleX), (int)(TILE_SY * scaleY)));
                    currentMapChunk.Dispose();
                }
            }

            try {
                mapBuffer_ground.bmp.Save(MAP_MINI_GROUND_CACHE);
                mapBuffer_object.bmp.Save(MAP_MINI_OBJECT_CACHE);
            } catch {
                MessageBox.Show("Minimap failed to save.");
            }

            minimap.Invalidate();
        }

        private void minimap_Paint(object sender, PaintEventArgs e) {
            if (REQUIRES_CLOSE) { this.Close(); return; }

            float scaleX = minimap.Width / (float)(TILE_SX * TILE_TX);
            float scaleY = minimap.Height / (float)(TILE_SY * TILE_TY);

            if (mapBuffer_ground == null || mapBuffer_object == null) DrawInitialFullMap();

            e.Graphics.Clear(BACKGROUND_COLOR);

            if (layer_floor.Checked) e.Graphics.DrawImage(mapBuffer_ground.bmp, Point.Empty);
            if (layer_objects.Checked) e.Graphics.DrawImage(mapBuffer_object.bmp, Point.Empty);

            //Draw the current view area.
            e.Graphics.DrawRectangle(new Pen(new SolidBrush(Color.Red)), (int)(viewArea.Left * scaleX), (int)(viewArea.Top * scaleY), (int)(viewArea.Width * scaleX), (int)(viewArea.Height * scaleY));
        }

        private void minimap_MouseClick(object sender, MouseEventArgs e) {
            //Need to pan there :)
            offsetX = (e.Location.X / (float)minimap.Width) * TILE_TX;
            offsetY = (e.Location.Y / (float)minimap.Height) * TILE_TY;

            offsetX = ((int)Math.Round(offsetX * 4)) / 4.0f;
            offsetY = ((int)Math.Round(offsetY * 4)) / 4.0f;

            FixViewArea();

            terrainRedrawRequired = true;

            mapViewPanel.Invalidate();
            minimap.Invalidate();
        }

        public void DrawWithObject(Image objectName) {
            paintMode = PaintMode.Objects;
            activeLayer = PaintLayers.Objects;
            obj_paint_original = objectName;

            DrawingHelper.FixObjectPaintingTransformation((float)obj_rot.Value, (float)obj_scale.Value, obj_flipX.Checked, obj_flipY.Checked, obj_paint_original, out obj_paint_image);
        }

        private void terrain_shape_btn_Click(object sender, EventArgs e) {
            if (paintShape == PaintShape.Circle) {
                paintShape = PaintShape.Square;
                terrain_shape_btn.Text = "Shape (Square)";
            } else {
                paintShape = PaintShape.Circle;
                terrain_shape_btn.Text = "Shape (Circle)";
            }
        }

        private void obj_settings_ValueChanged(object sender, EventArgs e) {
            DrawingHelper.FixObjectPaintingTransformation((float)obj_rot.Value, (float)obj_scale.Value, obj_flipX.Checked, obj_flipY.Checked, obj_paint_original, out obj_paint_image);
            drawPanel_ME_move(null, new MouseEventArgs(System.Windows.Forms.MouseButtons.None, 0, mousePos.X, mousePos.Y, 0));
        }
    }
}
