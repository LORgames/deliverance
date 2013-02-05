using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CityTools.Stories {
    class Story {
        internal int startLocation;
        internal int endLocation;
        internal short npcStartImage1;
        internal short npcStartImage2;
        internal short npcEndImage1;
        internal short npcEndImage2;
        internal int repLevel;
        internal byte resType;
        internal int quantity;
        internal string startText;
        internal string pickupText;
        internal string endText;

        public Story(int startLocation, int endLocation, short npcStartImage1, short npcStartImage2, short npcEndImage1, short npcEndImage2, int repLevel, byte resType, int quantity, string startText, string pickupText, string endText) {
            this.startLocation = startLocation;
            this.endLocation = endLocation;
            this.npcStartImage1 = npcStartImage1;
            this.npcStartImage2 = npcStartImage2;
            this.npcEndImage1 = npcEndImage1;
            this.npcEndImage2 = npcEndImage2;
            this.repLevel = repLevel;
            this.resType = resType;
            this.quantity = quantity;
            this.startText = startText;
            this.pickupText = pickupText;
            this.endText = endText;
        }
    }
}
