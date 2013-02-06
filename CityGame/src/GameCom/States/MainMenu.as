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
	public class MainMenu extends Sprite {
		//Buttons and stuff?
		private var background:Bitmap;
		
		private const totalButtons:int = 1;
		private const buttonPadding:int = 10;
		
		private var TextContainer:Sprite = new Sprite();
		private var PlayText:TextField = new TextField();
		private var ContinueText:TextField = new TextField();
		private var CreditsText:TextField = new TextField();
		private var WebsiteText:TextField = new TextField();
		
		public function MainMenu() {
			AudioController.PlayLoop(AudioStore.Music);
			
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			background = new Bitmap(ThemeManager.Get("Backgrounds/Menu.jpg"));
			
			//Start Menu
			this.addChild(background);
			
			this.addChild(TextContainer);
			
			PlayText.selectable = false;
			PlayText.defaultTextFormat = new TextFormat("Verdana", 36, 0xFFFFFF);
			PlayText.autoSize = TextFieldAutoSize.CENTER;
			PlayText.text = "New Game";
			PlayText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			PlayText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			PlayText.addEventListener(MouseEvent.CLICK, PlayFunc, false, 0, true);
			TextContainer.addChild(PlayText);
			
			ContinueText.selectable = false;
			ContinueText.defaultTextFormat = new TextFormat("Verdana", 36, 0xFFFFFF);
			ContinueText.autoSize = TextFieldAutoSize.CENTER;
			ContinueText.text = "Continue";
			ContinueText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			ContinueText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			ContinueText.addEventListener(MouseEvent.CLICK, ContinueFunc, false, 0, true);
			TextContainer.addChild(ContinueText);
			
			CreditsText.selectable = false;
			CreditsText.defaultTextFormat = new TextFormat("Verdana", 36, 0xFFFFFF);
			CreditsText.autoSize = TextFieldAutoSize.CENTER;
			CreditsText.text = "Credits";
			CreditsText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			CreditsText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			CreditsText.addEventListener(MouseEvent.CLICK, CreditsFunc, false, 0, true);
			TextContainer.addChild(CreditsText);
			
			WebsiteText.selectable = false;
			WebsiteText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			WebsiteText.autoSize = TextFieldAutoSize.CENTER;
			WebsiteText.text = "www.lorgames.com";
			WebsiteText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			WebsiteText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			WebsiteText.addEventListener(MouseEvent.CLICK, WebsiteFunc, false, 0, true);
			TextContainer.addChild(WebsiteText);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
		}
		
		public function PlayFunc(e:MouseEvent):void {
			Storage.Format();
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function ContinueFunc(e:MouseEvent):void {
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function CreditsFunc(e:MouseEvent):void {
			//SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function WebsiteFunc(e:MouseEvent):void {
			flash.net.navigateToURL(new URLRequest("http://www.lorgames.com"), "_blank");
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
			PlayText.y = 5;
			ContinueText.x = -ContinueText.width/2;
			ContinueText.y = PlayText.y + PlayText.height + 5;
			CreditsText.x = -CreditsText.width/2;
			CreditsText.y = ContinueText.y + ContinueText.height + 5;
			WebsiteText.x = -WebsiteText.width / 2;
			WebsiteText.y = CreditsText.y + CreditsText.height + 20;
		}
		
		public function MouseOverText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array(new GlowFilter(0xFF0000));
		}
		
		public function MouseOutText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array();
		}
		
	}

}