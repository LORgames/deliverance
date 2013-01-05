package LORgames.Localization {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class Strings {
		
		private static var StringTable:Array = new Array();
		private static var currentLang:String = "default";
		
		/**
		 * Fills the stringtable with default values (most likely from the english set)
		 */
		public static function FillWithDefaultValues() : void {
			StringTable["default"] = new Array();
			
			StringTable["default"]["PlayMenu"] = "Main Menu";
			StringTable["default"]["PlayGame"] = "Play";
			StringTable["default"]["PlayEditor"] = "Level Editor";
			StringTable["default"]["SaveWorld"] = "Save World";
			StringTable["default"]["LoadWorld"] = "Load World";
			StringTable["default"]["CopyHere"] = "Copy Level here...";
			StringTable["default"]["Username"] = "Username";
			StringTable["default"]["Password"] = "Password";
			StringTable["default"]["LoginSave"] = "Please Login To Save Your Game";
			StringTable["default"]["LORgamesAcc"] = "LORgames account:";
			StringTable["default"]["WaitingServer"] = "Waiting for the server to respond...";
			StringTable["default"]["DataWaiting"] = "Waiting for data...";
			StringTable["default"]["DataRecieved"] = "Data recieved... Processing.";
			StringTable["default"]["SelectImage"] = "Select Image";
			
			StringTable["default"]["Error-ScenaryMustBeOnGround"] = "Ground Scenary Objects must be placed above ground!";
			StringTable["default"]["Error-ScenaryMustBeUnderground"] = "Underground Scenary Objects must be placed inside of ground!";
			
			StringTable["default"]["Tool-Unnamed"] = "<MissingToolName>";
			StringTable["default"]["Tool-Build"] = "Bridge creation tools";
			StringTable["default"]["Tool-Camera"] = "Increase or Decrease the size of the camera viewport\n\nClick and drag the camera outlines to change the size of the viewport";
			StringTable["default"]["Tool-CarTool"] = "Spawn a variety of vehicles";
			StringTable["default"]["Tool-Clear"] = "Destroy everything you have purchased and get the resources back";
			StringTable["default"]["Tool-DrawGround"] = "Create the fixed ground of the world";
			StringTable["default"]["Tool-GroundBox"] = "Create Rectangular ground segments";
			StringTable["default"]["Tool-GroundCircle"] = "Create Circular ground segments";
			StringTable["default"]["Tool-LoadWorld"] = "Load a world you created earlier";
			StringTable["default"]["Tool-Node"] = "Create a fixed node for players to start building bridges";
			StringTable["default"]["Tool-People"] = "Spawn a variety of people";
			StringTable["default"]["Tool-Reset"] = "Go back to building your bridge to try a new approach to the problem!";
			StringTable["default"]["Tool-Rope"] = "Create lengths of rope! Click and drag at a node to start a length of rope. Let go of the mouse button at the desired end point.";
			StringTable["default"]["Tool-SaveWorld"] = "Save this world and continue editing";
			StringTable["default"]["Tool-Scenary"] = "Place background objects to decorate the world. Please note that when players load the map, these will be created after ALL the ground is; so before you place them you should ensure your ground is complete.";
			StringTable["default"]["Tool-ScenaryGround"] = "Decorations that must be placed on the ground.";
			StringTable["default"]["Tool-ScenaryUnderground"] = "Decorations to be placed on dirt or other materials";
			StringTable["default"]["Tool-Select"] = "Click on bridge components or click and drag to high multiple components that you want to delete or to allow objects to pass in front of them.";
			StringTable["default"]["Tool-Settings"] = "Tools to edit the world";
			StringTable["default"]["Tool-Test"] = "Test to see if your bridge is enough to get the people across!";
			StringTable["default"]["Tool-Wood"] = "Create linked wooden platforms! Click and drag at a node to start the platforms. Let go of the mouse button at the desired end point.";
			StringTable["default"]["Tool-WorldEdit"] = "Go back to modifying the level layout";
		}
		
		/**
		 * Loads a language so that Get returns the correct values
		 * @param	languageCode
		 */
		public static function LoadLanguage(languageCode:String = "en") : void {
			//TODO: Finish this function
		}
		
		/**
		 * Changes the current language to the one specified
		 * @param	languageCode	The new language code for the game
		 */
		public static function ChangeLanguage(languageCode:String = "en") :void {
			currentLang = languageCode;
		}
		
		/**
		 * 
		 * @param	string	The string to lookup in the table
		 * @return	string	The value found in the table
		 */
		public static function Get(string:String):String {
			if (StringTable[currentLang] is Array && StringTable[currentLang][string]) {
				return StringTable[currentLang][string];
			} else if (StringTable["default"] is Array && StringTable["default"][string]) {
				return StringTable["default"][string];
			} else {
				return string;
			}
		}
		
	}

}