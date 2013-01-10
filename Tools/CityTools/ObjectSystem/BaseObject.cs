using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Box2CS;
using CityTools.Box2D;
using System.Drawing;

namespace CityTools.ObjectSystem {
    public class BaseObject {
        //Circular references
        public Body baseBody;
        public BodyTags tag;

        //There might not be either of these things
        public BaseObject parent = null;
        public List<BaseObject> children = null;

        //Draw function
        public virtual void Draw(LBuffer buffer, RectangleF drawArea, float ZoomFactor, bool drawBoundingBoxes) {
            throw new NotImplementedException();
        }

        // Move function
        public virtual void Move(float x, float y) {
            throw new NotImplementedException();
        }

        // Delete function
        public virtual void Delete() {
            throw new NotImplementedException();
        }
    }
}
