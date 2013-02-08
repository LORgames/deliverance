package {
	import flash.display.Sprite;
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
	import mochi.as3.MochiAd;
	
	/**
	 * ...
	 * @author P. Fox
	 */
	public class Preloader extends MovieClip {
		
		private const AD_SIZE_X:int = 800;
		private const AD_SIZE_Y:int = 600;
		
		[Embed(source="../lib/_embeds/logo.png")]
        [Bindable]
        public static var Logo:Class;
		
		private var TextContainer:Sprite = new Sprite();
		
		private var DisplayText:TextField = new TextField();
		private var PercentageText:TextField = new TextField();
		
		private var adContainer:MovieClip = new MovieClip();
		
		private var isAdFinished:Boolean = true;
		private var isLoadingFinished:Boolean = false;
		
		public function Preloader() {
			if (stage) Init();
			else this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:*= null):void {
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			stage.addEventListener(Event.RESIZE, resize);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Show the Loader
			this.addChild(TextContainer);
			
			PercentageText.selectable = false;
			PercentageText.defaultTextFormat = new TextFormat("Verdana", 40, 0xFFFFFF);
			PercentageText.autoSize = TextFieldAutoSize.CENTER;
			PercentageText.text = "0.00%";
			TextContainer.addChild(PercentageText);
			
			DisplayText.defaultTextFormat = new TextFormat("Verdana", 16, 0xFFFFFF);
			DisplayText.autoSize = TextFieldAutoSize.CENTER;
			DisplayText.selectable = false;
			TextContainer.addChild(DisplayText);
			
			//this.addChild(adContainer);
			//MochiAd.showPreGameAd({clip:adContainer, id:"c3ebe5c39a9741ba", res:stage.stageWidth+"x"+stage.stageHeight, ad_finished:fAdFinished});
			
			resize(null);
		}
		
		public function fAdFinished():void {
			this.removeChild(adContainer);
			isAdFinished = true;
			
			CleanUp();
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			var totalBytes:int = e.bytesTotal;
			var approx:Boolean = false;
			
			if (e.bytesTotal == 0) {
				totalBytes = 10627557;
				approx = true;
			}
			
			// Update the GUI
			if (e.bytesLoaded != totalBytes) {
				PercentageText.text = (approx?"~":"") + Number(e.bytesLoaded / totalBytes * 100.0).toFixed(1) + "%";
				DisplayText.text = "Downloading.";
			} else {
				DisplayText.text = "Unpacking.";
			}
		}
		
		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function resize(e:Event):void {
			// Show the Loader
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			var bmp:Bitmap = new Logo() as Bitmap;
			var mat:Matrix = new Matrix(1, 0, 0, 1, (stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2);

			this.graphics.beginBitmapFill(bmp.bitmapData, mat, false, false);
			this.graphics.drawRect((stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2, bmp.width, bmp.height);
			this.graphics.endFill();
			
			TextContainer.x = mat.tx + 448 + 261/2;
			TextContainer.y = mat.ty + 241;
			
			PercentageText.x = -PercentageText.width / 2;
			PercentageText.y = 65;
			
			DisplayText.x = -DisplayText.width / 2;
			DisplayText.y = 50;
			
			//adContainer.x = (stage.stageWidth - AD_SIZE_X) / 2;
			//adContainer.y = (stage.stageHeight - AD_SIZE_Y) / 2;
		}
		
		private function loadingFinished():void {
			isLoadingFinished = true;
			
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			PercentageText.text = "";
			DisplayText.text = "Watching Ad";
			
			CleanUp();
		}
		
		public function CleanUp():void {
			if (!isLoadingFinished || !isAdFinished) return;
			
			stage.removeEventListener(Event.RESIZE, resize);
			
			// Hide the loader
			TextContainer.removeChild(DisplayText);
			TextContainer.removeChild(PercentageText);
			this.removeChild(TextContainer);
			
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