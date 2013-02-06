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

        internal int repGain;
        internal int monGain;

        internal string startText;
        internal string pickupText;
        internal string endText;

        internal byte numEnemies;

        public Story(int startLocation, int endLocation, short npcStartImage1, short npcStartImage2, short npcEndImage1, short npcEndImage2, int repLevel, int repGain, int monGain, string startText, string pickupText, string endText, byte numEnemies) {
            this.startLocation = startLocation;
            this.endLocation = endLocation;
            this.npcStartImage1 = npcStartImage1;
            this.npcStartImage2 = npcStartImage2;
            this.npcEndImage1 = npcEndImage1;
            this.npcEndImage2 = npcEndImage2;
            this.repLevel = repLevel;

            this.repGain = repGain;
            this.monGain = monGain;

            this.startText = startText;
            this.pickupText = pickupText;
            this.endText = endText;

            this.numEnemies = numEnemies;
        }
    }
}
