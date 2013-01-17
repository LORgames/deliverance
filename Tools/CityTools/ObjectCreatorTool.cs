using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CityTools.Core;
using CityTools.ObjectSystem;
using CityTools.Physics;
using CityTools.Components;

namespace CityTools {
    public partial class ObjectCreatorTool : Form {
        Image precache;

        LBuffer s_buffer;
        LBuffer i_buffer;

        int objectID = 0;

        Point p0;
        Point p1;

        PaintMode pm = PaintMode.Off;
        PhysicsShapes ps = PhysicsShapes.Rectangle;

        public ObjectCreatorTool (int objectID) {
            this.objectID = objectID;
            
            InitializeComponent();

            precache = ImageCache.RequestImage(ScenicObjectCache.s_objectTypes[objectID].ImageName);
            System.Diagnostics.Debug.WriteLine(precache.Size);

            s_buffer = new LBuffer(pictureBox1.DisplayRectangle);
            i_buffer = new LBuffer(pictureBox1.DisplayRectangle);
        }

        private void pictureBox1_Paint(object sender, PaintEventArgs e) {
            s_buffer.gfx.Clear(Color.Transparent);

            s_buffer.gfx.DrawImage(precache, new Rectangle(Point.Empty, precache.Size));

            foreach (PhysicsShape p in ScenicObjectCache.s_objectTypes[objectID].Physics) {
                p.DrawMe(s_buffer.gfx, PointF.Empty, Pens.Yellow, new SolidBrush(Color.FromArgb(128, Color.Yellow)));
            }

            e.Graphics.DrawImage(s_buffer.bmp, Point.Empty);
            e.Graphics.DrawImage(i_buffer.bmp, Point.Empty);
        }

        private void pictureBox1_Resize(object sender, EventArgs e) {
            s_buffer = new LBuffer(pictureBox1.DisplayRectangle);
        }

        private void setShape(object sender, EventArgs e) {
            if ((sender as Button).Text == "Square") {
                pm = PaintMode.Physics;
                ps = PhysicsShapes.Rectangle;
            } else if ((sender as Button).Text == "Circle") {
                pm = PaintMode.Physics;
                ps = PhysicsShapes.Circle;
            } else if ((sender as Button).Text == "Clear Physics") {
                ScenicObjectCache.s_objectTypes[objectID].Physics.Clear();
                pictureBox1.Invalidate();
            }
        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e) {
            i_buffer.gfx.Clear(Color.Transparent);

            p0 = e.Location;
            p1 = e.Location;
        }

        private void pictureBox1_MouseUp(object sender, MouseEventArgs e) {
            i_buffer.gfx.Clear(Color.Transparent);
            
            if (e.Button == MouseButtons.Left && pm == PaintMode.Physics) {
                p1 = e.Location;

                p0.X = Math.Max(p0.X, 0);
                p0.Y = Math.Max(p0.Y, 0);
                p1.X = Math.Max(p1.X, 0);
                p1.Y = Math.Max(p1.Y, 0);

                if (ps == PhysicsShapes.Rectangle) {
                    ScenicObjectCache.s_objectTypes[objectID].Physics.Add(new PhysicsRectangle(new RectangleF(Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y))));
                } else if (ps == PhysicsShapes.Circle) {
                    ScenicObjectCache.s_objectTypes[objectID].Physics.Add(new PhysicsCircle(new RectangleF(Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.X - p0.X))));
                }
            }

            pictureBox1.Invalidate();
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e) {
            if (e.Button == MouseButtons.Left && pm == PaintMode.Physics) {
                i_buffer.gfx.Clear(Color.Transparent);

                p1 = e.Location;

                if (ps == PhysicsShapes.Rectangle) {
                    i_buffer.gfx.DrawRectangle(Pens.Red, Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.Y - p0.Y));
                } else if (ps == PhysicsShapes.Circle) {
                    i_buffer.gfx.DrawEllipse(Pens.Red, Math.Min(p0.X, p1.X), Math.Min(p0.Y, p1.Y), Math.Abs(p1.X - p0.X), Math.Abs(p1.X - p0.X));
                }

                pictureBox1.Invalidate();
            }
        }

        private void ObjectCreatorTool_FormClosing(object sender, FormClosingEventArgs e) {
            (MainWindow.instance.obj_scenary_objs.Controls[0] as ObjectCacheControl).Activate();
        }
    }
}
