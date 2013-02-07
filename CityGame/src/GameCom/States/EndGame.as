package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import GameCom.Helpers.AudioStore;
	import GameCom.SystemMain;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Keys;
	import LORgames.Engine.Storage;
	import LORgames.Localization.Strings;
	import mx.core.BitmapAsset;
	
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class EndGame extends Sprite {
		//Buttons and stuff?
		private var background:Bitmap;
		
		private const totalButtons:int = 1;
		private const buttonPadding:int = 10;
		
		private var TextContainer:Sprite = new Sprite();
		private var PlayText:TextField = new TextField();
		private var EndText:TextField = new TextField();
		
		public function EndGame() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			background = new Preloader.Logo();
			
			//Start Menu
			this.addChild(background);
			
			this.addChild(TextContainer);
			
			PlayText.selectable = false;
			PlayText.defaultTextFormat = new TextFormat("Verdana", 36, 0xFFFFFF);
			PlayText.autoSize = TextFieldAutoSize.CENTER;
			PlayText.text = "Main Menu";
			PlayText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			PlayText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			PlayText.addEventListener(MouseEvent.CLICK, PlayFunc, false, 0, true);
			TextContainer.addChild(PlayText);
			
			EndText.selectable = false;
			EndText.defaultTextFormat = new TextFormat("Verdana", 20, 0xFFFFFF);
			EndText.autoSize = TextFieldAutoSize.CENTER;
			EndText.text = "Congratulations! You saved the city and got filthy rich off mob money, I'm sure that won't come back to bite you.";
			EndText.wordWrap = true;
			TextContainer.addChild(EndText);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
		}
		
		public function PlayFunc(e:MouseEvent):void {
			SystemMain.instance.StateTo(new MainMenu());
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			background.x = (this.stage.stageWidth - background.width) / 2;
			background.y = (this.stage.stageHeight - background.height) / 2;
			
			TextContainer.x = background.x + 448 + 261/2;
			TextContainer.y = background.y + 241;
			
			PlayText.x = -PlayText.width/2;
			PlayText.y = 150;
			
			EndText.width = 261;
			EndText.x = -EndText.width / 2;
			EndText.y = 0;
		}
		
		public function MouseOverText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array(new GlowFilter(0x337C8C));
		}
		
		public function MouseOutText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array();
		}
		
	}

}