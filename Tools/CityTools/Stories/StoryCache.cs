using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;
using CityTools.Components;

namespace CityTools.Stories {
    class StoryCache {

        public const string STORY_DATABASE = Program.CACHE;
        public const string STORY_DATAFILE = STORY_DATABASE + "story_data.bin";

        public static List<Story> stories = new List<Story>();

        public static void InitializeCache() {
            if (!Directory.Exists(STORY_DATABASE)) {
                Directory.CreateDirectory(STORY_DATABASE);
            }

            if (File.Exists(STORY_DATAFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(STORY_DATAFILE));

                // Add Stories
                int totalStories = f.GetInt();

                for (int i = 0; i < totalStories; i++) {
                    int startLocation = f.GetInt();
                    int endLocation = f.GetInt();
                    short npcStartImage1 = f.GetShort();
                    short npcStartImage2 = f.GetShort();
                    short npcEndImage1 = f.GetShort();
                    short npcEndImage2 = f.GetShort();
                    int repLevel = f.GetInt();
                    byte resType = f.GetByte();
                    int quantity = f.GetInt();
                    string startText = f.GetString();
                    string pickupText = f.GetString();
                    string endText = f.GetString();

                    stories.Add(new Story(startLocation, endLocation, npcStartImage1, npcStartImage2, npcEndImage1, npcEndImage2, repLevel, resType, quantity, startText, pickupText, endText));
                }
            }
        }

        public static void AddStory(Story story) {
            stories.Add(story);

            try {
                (MainWindow.instance.story_storyPan.Controls[0] as StoryCacheControl).UpdateWhenRequired();
            } catch { }
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();

            // Store number of nodes
            f.AddInt(stories.Count);

            // Store each nodes index and position
            foreach (Story story in stories) {
                f.AddInt(story.startLocation);
                f.AddInt(story.endLocation);
                f.AddShort(story.npcStartImage1);
                f.AddShort(story.npcStartImage2);
                f.AddShort(story.npcEndImage1);
                f.AddShort(story.npcEndImage2);
                f.AddInt(story.repLevel);
                f.AddByte(story.resType);
                f.AddInt(story.quantity);
                f.AddString(story.startText);
                f.AddString(story.pickupText);
                f.AddString(story.endText);
            }

            f.Encode(STORY_DATAFILE);
        }
    }
}
