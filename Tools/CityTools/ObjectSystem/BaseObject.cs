using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Box2CS;
using CityTools.Box2D;
using System.Drawing;
using CityTools.Core;

namespace CityTools.ObjectSystem {
    public class BaseObject : IComparable<BaseObject> {
        //Circular references
        public Body baseBody;
        public BodyTags tag;

        // For indexing
        internal static int CURRENT_INDEX = 0;
        public int index = 0;

        // Constructor for indexing and sorting
        public BaseObject() {
            index = CURRENT_INDEX++;
        }

        //Draw function
        public virtual void Draw(LBuffer buffer) {
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

        public int CompareTo(BaseObject other) {
            return index.CompareTo(other.index);
        }
    }
}
