package {
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	import deng.fzip.FZipLibrary;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class ThemeManager {
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		// Embeded Default images (done this way to make sure default program is 1 file rather than a few)
		/////////////////////////////////////////////////////////////////////////////////////////////////////
		
		[Embed(source="../lib/_embeds/default.zip", mimeType = 'application/octet-stream')]
        [Bindable]
        private static var DefaultBytes:Class;
		
		private static var currentTheme:String = "";
		private static var themeSet:Array = new Array();
		
		private static var zipLib:FZipLibrary;
		private static var currentlyLoading:String = "";
		private static var zip:FZip = new FZip();
		private static var loader:Loader = new Loader();
		private static var imageLoadList:Array = new Array();
		private static var themeLoadList:Array = new Array();
		private static var finLoad:Array = new Array();
		
		public static function Initialize(run:Function = null):void {
			LoadTheme("Default");
			ChangeTheme("Default", run);
		}
		
		private static function LoadHook(theme:String, run:Function = null):void {
			if (finLoad[theme] == null) {
				finLoad[theme] = new Array();
			}
			
			(finLoad[theme] as Array).push(run);
		}
		
		public static function ChangeTheme(themeName:String, hook:Function):void {
			//Exit if changing to the current theme
			if (themeName == currentTheme) return;
			
			if (HasTheme(themeName)) {
				hook();
			} else {
				LoadHook(themeName, hook);
				LoadTheme(themeName);
			}
			
			currentTheme = themeName;
		}
		
		public static function Get(string:String):* {
			if (themeSet[currentTheme] is Array && themeSet[currentTheme][string]) {
				return themeSet[currentTheme][string];
			} else if (themeSet["Default"] is Array && themeSet["Default"][string]) {
				return themeSet["Default"][string];
			} else {
				return null;
			}
		}
		
		public static function GetFilenamesByWildcard(string:String):Array {
			var retList:Array = new Array();
			
			for (var s:String in (themeSet[currentTheme] as Array)) {
				if (s.indexOf(string) != -1) {
					retList.push(s);
				}
			}
			
			return retList;
		}
		
		private static function LoadedThemeZip(e:Event):void {
			zipLib = new FZipLibrary();
			
			zipLib.formatAsBitmapData(".gif");
			zipLib.formatAsBitmapData(".jpg");
			//zipLib.formatAsBitmapData(".png");
			zipLib.formatAsDisplayObject(".swf");
			
			zipLib.addEventListener(Event.COMPLETE, ProcessedThemeZip, false, 0, true);
			zipLib.addZip(zip);
		}
		
		private static function ProcessedThemeZip(e:Event):void {
			if (currentlyLoading == "") return;
			if (themeSet[currentlyLoading] != null) throw new Error("Uhoh!");
			
			themeSet[currentlyLoading] = new Array();
			var f:FZipFile;
			
			for (var i:int = 0; i < zip.getFileCount(); i++) {
				f = zip.getFileAt(i);
				
				var ext:String = f.filename.substr(f.filename.lastIndexOf("."));
				if (/*ext == ".png" || */ext == ".jpg" || ext == ".bmp") {
					themeSet[currentlyLoading][f.filename] = zipLib.getBitmapData(f.filename);
				} else {
					themeSet[currentlyLoading][f.filename] = f.content;
				}
			}
			
			if (finLoad[currentlyLoading] != null) {
				while ((finLoad[currentlyLoading] as Array).length > 0){
					((finLoad[currentlyLoading] as Array).pop() as Function).call();
				}
				finLoad[currentlyLoading] = null;
			}
			
			currentlyLoading = "";
			if (themeLoadList.length > 0) {
				LoadTheme(themeLoadList.pop());
			}
		}
		
		public static function HasTheme(themeName:String):Boolean {
			return (themeSet[themeName] is Array);
		}
		
		/**
		 * Loads a theme; The location is not as important to this function as the
		 * @param	themeName
		 */
		public static function LoadTheme(themeName:String):void {
			if (!HasTheme(themeName)) {
				if (currentlyLoading != "") {
					themeLoadList.push(themeName);
				} else {
					currentlyLoading = themeName;
					
					zip = new FZip();
					zip.addEventListener(Event.COMPLETE, LoadedThemeZip, false, 0, true);
					
					if(themeName != "Default") {
						zip.load(new URLRequest(Global.SERVER_ADDR + "/themes/" + themeName + ".zip"));
					} else {
						var bytes:ByteArray = new DefaultBytes() as ByteArray;
						zip.loadBytes(bytes);
					}
				}
			}
		}
		
	}

}