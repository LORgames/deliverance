package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
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
		private var WebsiteText:TextField = new TextField();
		private var CreditsText:TextField = new TextField();
		
		public function MainMenu() {
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			//Start Menu
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
			
			WebsiteText.selectable = false;
			WebsiteText.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			WebsiteText.autoSize = TextFieldAutoSize.CENTER;
			WebsiteText.text = "www.lorgames.com";
			WebsiteText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			WebsiteText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			WebsiteText.addEventListener(MouseEvent.CLICK, WebsiteFunc, false, 0, true);
			TextContainer.addChild(WebsiteText);
			
			CreditsText.selectable = false;
			CreditsText.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
			CreditsText.autoSize = TextFieldAutoSize.CENTER;
			CreditsText.htmlText = "LORgames: Paul 'OsiJr' Fox, Ryan 'HarkonX' Furlong, Ying 'ohoshiio' Luo, Samuel 'samsinsane' Surtees, Miles 'mozza_26' Till and Nathan 'Nazka' Wentwoth-Perry.\n\nPowered by FZip and Box2DFlashAS3.";
			CreditsText.wordWrap = true;
			CreditsText.width = 274;
			this.addChild(CreditsText);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
		}
		
		public function PlayFunc(e:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			Storage.Format();
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function ContinueFunc(e:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function WebsiteFunc(e:MouseEvent):void {
			AudioController.PlaySound(AudioStore.MenuClick);
			flash.net.navigateToURL(new URLRequest("http://www.lorgames.com"), "_blank");
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			var bmp:Bitmap = new Preloader.Logo() as Bitmap;
			var mat:Matrix = new Matrix(1, 0, 0, 1, (stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2);

			this.graphics.beginBitmapFill(bmp.bitmapData, mat, false, false);
			this.graphics.drawRect((stage.stageWidth - bmp.width) / 2, (stage.stageHeight - bmp.height) / 2, bmp.width, bmp.height);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x0, 0.7);
			this.graphics.lineStyle(2);
			this.graphics.drawRoundRect(mat.tx + 438, mat.ty + 460, CreditsText.width+10, CreditsText.height+10, 20);
			
			TextContainer.x = mat.tx + 448 + 261/2;
			TextContainer.y = mat.ty + 241;
			
			PlayText.x = -PlayText.width/2;
			PlayText.y = 15;
			ContinueText.x = -ContinueText.width/2;
			ContinueText.y = PlayText.y + PlayText.height + 15;
			WebsiteText.x = -WebsiteText.width / 2;
			WebsiteText.y = ContinueText.y + ContinueText.height + 30;
			
			CreditsText.x = mat.tx + 443;
			CreditsText.y = mat.ty + 465;
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