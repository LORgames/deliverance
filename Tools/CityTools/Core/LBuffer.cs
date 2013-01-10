using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace CityTools.Core {
    public class LBuffer {
        public Bitmap bmp;
        public Graphics gfx;

        public LBuffer(object _s = null) {
            Rectangle size;

            if (_s == null || !(_s is Rectangle)) {
                size = MainWindow.instance.drawArea;
            } else {
                size = (Rectangle)_s;
            }

            bmp = new Bitmap(size.Width, size.Height, System.Drawing.Imaging.PixelFormat.Format32bppPArgb);
            gfx = Graphics.FromImage(bmp);

            gfx.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBilinear;
            gfx.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
            gfx.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
        }
    }
}
