﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using CityTools.Core;
using System.Windows.Forms;
using CityTools.Physics;
using System.Drawing;

namespace CityTools.Places {
    public class PlacesObjectCache {
        public const string PLACES_TYPEFILE = Program.CACHE + "places_types.bin";
        public const string PLACES_USERFILE = Program.CACHE + "places_store.bin";
        public const string PLACES_FOLDER = ".\\Places";

        public const string RESOURCES_FILE = Program.CACHE + "Resources.csv";
        public const string PEOPLE_FILE = Program.CACHE + "People.csv";

        private static int _highestTypeIndex = 0;

        public static Dictionary<int, int> ObjectUsageCountsAtLoad = new Dictionary<int, int>();

        public static Dictionary<int, PlacesType> s_objectTypes = new Dictionary<int, PlacesType>();
        public static Dictionary<string, int> s_StringToInt = new Dictionary<string, int>();

        public static List<PlacesObject> s_objectStore = new List<PlacesObject>();

        public static List<String> resources = new List<string>();
        public static List<int> resources_min = new List<int>();
        public static List<int> resources_max = new List<int>();
        public static List<float> resources_rep = new List<float>();
        public static List<float> resources_money = new List<float>();

        public static List<String> people = new List<string>();

        public static void InitializeCache() {
            if (!Directory.Exists(PLACES_FOLDER)) {
                Directory.CreateDirectory(PLACES_FOLDER);
            }

            // Load object types from file
            if (File.Exists(PLACES_TYPEFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(PLACES_TYPEFILE));

                int totalShapes = f.GetInt();
                _highestTypeIndex = f.GetInt();

                //This is where we load the BASIC information
                for (int i = 0; i < totalShapes; i++) {
                    int type_id = f.GetInt();
                    string source = f.GetString();

                    ObjectUsageCountsAtLoad.Add(type_id, 0);

                    s_objectTypes.Add(type_id, new PlacesType(type_id, source));
                    s_StringToInt.Add(source, type_id);
                }
            }

            //Scan for new objects
            foreach (string filename in Directory.GetFiles(PLACES_FOLDER, "*.png", SearchOption.AllDirectories)) {
                if (!ImageCache.HasCached(filename)) {
                    _highestTypeIndex++;
                    s_objectTypes.Add(_highestTypeIndex, new PlacesType(_highestTypeIndex, filename));
                    s_StringToInt.Add(filename, _highestTypeIndex);

                    ObjectUsageCountsAtLoad.Add(_highestTypeIndex, 0);
                }
            }

            // Load object instances from file
            if (File.Exists(PLACES_USERFILE)) {
                BinaryIO f = new BinaryIO(File.ReadAllBytes(PLACES_USERFILE));
                int totalShapes = f.GetInt();

                for (int i = 0; i < totalShapes; i++) {
                    int sourceID = f.GetInt();
                    float locationX = f.GetFloat();
                    float locationY = f.GetFloat();
                    int rotation = f.GetInt();

                    ObjectUsageCountsAtLoad[sourceID] = ObjectUsageCountsAtLoad[sourceID] + 1;

                    PlacesObject p = new PlacesObject(sourceID, new System.Drawing.PointF(locationX, locationY), rotation, false);
                    p.ReadPersonalData(f);
                    s_objectStore.Add(p);
                }
            }

            //Load the people in
            string[] people_lines = File.ReadAllLines(PEOPLE_FILE);
            for (int i = 0; i < people_lines.Length; i++) {
                string resLine = people_lines[i];
                string name = resLine.Split('|')[1];
                people.Add(name);

                ToolStripMenuItem tsi = (MainWindow.instance.placesPeopleContextMenu.Items.Add(name) as ToolStripMenuItem);
                tsi.CheckOnClick = true;
            }

            //Load the resources in
            string[] resources_lines = File.ReadAllLines(RESOURCES_FILE);
            for(int i = 1; i < resources_lines.Length; i++) {
                string resLine = resources_lines[i];
                string name = resLine.Split(',')[1];
                resources.Add(name);

                resources_min.Add(int.Parse(resLine.Split(',')[3]));
                resources_max.Add(int.Parse(resLine.Split(',')[4]));

                resources_money.Add(float.Parse(resLine.Split(',')[2]));
                resources_rep.Add(float.Parse(resLine.Split(',')[7]));

                ToolStripMenuItem tsi = (MainWindow.instance.placesResourcesContextMenu.Items.Add(name) as ToolStripMenuItem);
                tsi.CheckOnClick = true;
            }
        }

        static void resDD_DropDownClosed(object sender, EventArgs e) {
            
        }

        public static void AddShape(PlacesObject shape) {
            s_objectStore.Add(shape);
        }

        public static void SaveTypes() {
            //Count physics objects first...
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectTypes.Count);
            f.AddInt(_highestTypeIndex);

            foreach (KeyValuePair<int, PlacesType> kvp in s_objectTypes) {
                f.AddInt(kvp.Key);
                f.AddString(kvp.Value.ImageName);
            }

            f.Encode(PLACES_TYPEFILE);
        }

        public static void SaveCache() {
            BinaryIO f = new BinaryIO();
            f.AddInt(s_objectStore.Count);

            foreach (PlacesObject ps in s_objectStore) {
                f.AddInt(ps.object_index);
                f.AddFloat(ps.baseBody.Position.X);
                f.AddFloat(ps.baseBody.Position.Y);
                f.AddInt(ps.angle);

                ps.WritePersonalData(f);
            }

            f.Encode(PLACES_USERFILE);
        }
    }
}
