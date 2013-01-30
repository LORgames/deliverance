package {
	import GameCom.Helpers.SpriteHelper;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author P. Fox
	 */
	public class Preloader extends MovieClip {
		
		[Embed(source="../lib/_embeds/logo.png")]
        [Bindable]
        private static var Logo:Class;
		
		private var gameNameTF:TextField = new TextField();
		private var progressTF:TextField = new TextField();
		
		public function Preloader() {
			if (stage) Init();
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:*= null):void {
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Show the Loader
			this.graphics.beginFill(0xFFFFFF, 1);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			var bmp:Bitmap = new Logo() as Bitmap;
			var mat:Matrix = new Matrix(1, 0, 0, 1, (stage.stageWidth / 2) - (bmp.width / 2), (stage.stageHeight / 2) - (bmp.height / 2));

			this.graphics.beginBitmapFill(bmp.bitmapData, mat, false, false);
			this.graphics.drawRect((stage.stageWidth / 2) - (bmp.width / 2), (stage.stageHeight / 2) - (bmp.height / 2), bmp.width, bmp.height);
			this.graphics.endFill();
			
			progressTF.y = 30;
			progressTF.x = 15;
			progressTF.defaultTextFormat = new TextFormat("Verdana", 20 * Global.UI_SCALE, 0x000000);
			progressTF.autoSize = TextFieldAutoSize.LEFT;
			progressTF.selectable = false;
			this.addChild(progressTF);
			
			gameNameTF.x = 5;
			gameNameTF.autoSize = TextFieldAutoSize.LEFT;
			gameNameTF.selectable = false;
			gameNameTF.defaultTextFormat = new TextFormat("Verdana", 30 * Global.UI_SCALE, 0x000000);
			this.addChild(gameNameTF);
			gameNameTF.text = Global.GAME_NAME;
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			var totalBytes = Math.max(e.bytesTotal, 7*1024*1024);
			
			// Update the GUI
			if(e.bytesLoaded != totalBytes) {
				progressTF.text = "Loading " + (Math.floor(e.bytesLoaded / e.bytesTotal * 10000) / 100) + "% BL:" + e.bytesLoaded + " BT:" + totalBytes;
			} else {
				progressTF.text = "Unpacking...";
			}
		}
		
		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			progressTF.text = "Preparing...";
			//ThemeManager.Initialize(CleanUp);
			
			CleanUp();
		}
		
		public function CleanUp():void {
			// Hide the loader
			this.removeChild(progressTF);
			this.removeChild(gameNameTF);
			this.graphics.clear();
			startup();
		}
		
		private function startup():void {
			var mainClass:Class = null;
			
			try {
				mainClass = getDefinitionByName("Wrapper") as Class;
			} catch (ex:Error) {
				mainClass = null;
			}
			
			if (mainClass == null) mainClass = getDefinitionByName("Main") as Class;
			
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}