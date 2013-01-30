using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CityTools.Stories {
    class Story {
        internal int startLocation;
        internal int endLocation;
        internal short npcImage;
        internal int repLevel;
        internal byte resType;
        internal int quantity;
        internal string startText;
        internal string endText;

        public Story(int startLocation, int endLocation, short npcImage, int repLevel, byte resType, int quantity, string startText, string endText) {
            this.startLocation = startLocation;
            this.endLocation = endLocation;
            this.npcImage = npcImage;
            this.repLevel = repLevel;
            this.resType = resType;
            this.quantity = quantity;
            this.startText = startText;
            this.endText = endText;
        }
    }
}
