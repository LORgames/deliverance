using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace CityTools.Terrain {
    public class TerrainCrusher {

        public static void CrushAll() {
            MapCache.ReleaseAll();

            int crushedFailures = 0;

            if (MessageBox.Show("Warning, this operation takes a long time and the application will be unresponsive until it is complete. Do you wish to continue?", "WARNING!", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes) {
                for (int i = 0; i < MainWindow.TILE_TX; i++) {
                    for (int j = 0; j < MainWindow.TILE_TY; j++) {
                        try {
                            File.Move(MapCache.GetTileFilename(i, j), MapCache.GetTileFilename(i, j) + "2");

                            Process p = new Process();

                            p.StartInfo.FileName = "pngcrush.exe";
                            p.StartInfo.Arguments = MapCache.GetTileFilename(i, j) + "2 " + MapCache.GetTileFilename(i, j);
                            p.StartInfo.WindowStyle = ProcessWindowStyle.Maximized;
                            p.Start();
                            p.WaitForExit();

                            File.Delete(MapCache.GetTileFilename(i, j) + "2");
                        } catch {
                            crushedFailures++;
                        }
                    }
                }

                MessageBox.Show("Crush failures: " + crushedFailures);
            }
        }

    }
}
