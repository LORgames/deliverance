using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CityTools.Stories {
    class Story {
        internal int startLocation;
        internal int endLocation;
        internal short npcImage1;
        internal short npcImage2;
        internal int repLevel;
        internal byte resType;
        internal int quantity;
        internal string startText;
        internal string pickupText;
        internal string endText;

        public Story(int startLocation, int endLocation, short npcImage1, short npcImage2, int repLevel, byte resType, int quantity, string startText, string pickupText, string endText) {
            this.startLocation = startLocation;
            this.endLocation = endLocation;
            this.npcImage1 = npcImage1;
            this.npcImage2 = npcImage2;
            this.repLevel = repLevel;
            this.resType = resType;
            this.quantity = quantity;
            this.startText = startText;
            this.pickupText = pickupText;
            this.endText = endText;
        }
    }
}
