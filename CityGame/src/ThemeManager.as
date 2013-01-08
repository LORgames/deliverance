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
		
		private static var themeSet:Array = new Array();
		
		private static var zipLib:FZipLibrary;
		private static var zip:FZip = new FZip();
		private static var loader:Loader = new Loader();
		private static var imageLoadList:Array = new Array();
		private static var finLoad:Array = new Array();
		
		public static function Initialize(run:Function = null):void {
			zip = new FZip();
			zip.addEventListener(Event.COMPLETE, LoadedThemeZip, false, 0, true);
			
			var bytes:ByteArray = new DefaultBytes() as ByteArray;
			zip.loadBytes(bytes);
			
			LoadHook(run);
		}
		
		private static function LoadHook(run:Function = null):void {
			(finLoad as Array).push(run);
		}
		
		public static function Get(string:String):* {
			if (themeSet[string]) {
				return themeSet[string];
			} else {
				return null;
			}
		}
		
		public static function GetClassFromSWF(swfFilename:String, classname:String):Class {
			return (zipLib.getDefinition(swfFilename, classname) as Class);
		}
		
		public static function GetFilenamesByWildcard(string:String):Array {
			var retList:Array = new Array();
			
			for (var s:String in (themeSet as Array)) {
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
			zipLib.formatAsBitmapData(".png");
			zipLib.formatAsDisplayObject(".swf");
			
			zipLib.addEventListener(Event.COMPLETE, ProcessedThemeZip, false, 0, true);
			zipLib.addZip(zip);
		}
		
		private static function ProcessedThemeZip(e:Event):void {
			themeSet = new Array();
			var f:FZipFile;
			
			for (var i:int = 0; i < zip.getFileCount(); i++) {
				f = zip.getFileAt(i);
				
				var ext:String = f.filename.substr(f.filename.lastIndexOf("."));
				if (ext == ".png" || ext == ".jpg" || ext == ".bmp") {
					themeSet[f.filename] = zipLib.getBitmapData(f.filename);
				} else if (ext == ".swf") {
					themeSet[f.filename] = zipLib.getDisplayObject(f.filename);
				} else {
					themeSet[f.filename] = f.content;
				}
			}
			
			while ((finLoad as Array).length > 0){
				((finLoad as Array).pop() as Function).call();
			}
		}
		
	}

}