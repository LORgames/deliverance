using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace CityTools {
    public class DrawingHelper {
        public static void FixObjectPaintingTransformation(float rotationAngle, float scale, bool flipX, bool flipY, Image original, out Bitmap copy) {
            if (rotationAngle > 180)
                rotationAngle -= 360;

            float a_rotationAngle = Math.Abs(rotationAngle);

            float dW = (float)original.Width;
            float dH = (float)original.Height;

            if (a_rotationAngle > 90) a_rotationAngle -= 90;

            float radians = 0.0174532925f * a_rotationAngle;
            float dSin = (float)Math.Sin(radians);
            float dCos = (float)Math.Cos(radians);

            int iW, iH;

            if (a_rotationAngle <= 90) {
                iW = (int)(dH * dSin + dW * dCos);
                iH = (int)(dW * dSin + dH * dCos);
            } else {
                iW = (int)(dW * dSin + dH * dCos);
                iH = (int)(dH * dSin + dW * dCos);
            }

            int iX = (iW - original.Width) / 2;
            int iY = (iH - original.Height) / 2;

            copy = new Bitmap(iW, iH);
            copy.SetResolution(original.HorizontalResolution, original.VerticalResolution);

            Graphics g = Graphics.FromImage(copy);

            g.TranslateTransform(iX + original.Width / 2, iY + original.Height / 2);
            g.RotateTransform(rotationAngle);
            g.TranslateTransform(-iX - original.Width / 2, -iY - original.Height / 2);

            g.DrawImage(original, new Point(iX, iY));
            //g.DrawImage(obj_paint_original, Point.Empty);

            g.Dispose();
        }
    }
}
