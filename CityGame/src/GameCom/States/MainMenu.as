package GameCom.States {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
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
		
		private var PlayBtn:Button = new Button(Strings.Get("PlayGame"), 265, 54);
		private var ClearBtn:Button = new Button("CLEAR SAVE");
		
		private var TextContainer:Sprite = new Sprite();
		private var PlayText:TextField = new TextField();
		
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
			
			//TextContainer.width = 261;
			//TextContainer.height = 198;
			this.addChild(TextContainer);
			
			PlayText.selectable = false;
			PlayText.defaultTextFormat = new TextFormat("Verdana", 36, 0xFFFFFF);
			PlayText.autoSize = TextFieldAutoSize.CENTER;
			PlayText.text = "Play";
			PlayText.addEventListener(MouseEvent.ROLL_OVER, MouseOverText);
			PlayText.addEventListener(MouseEvent.ROLL_OUT, MouseOutText);
			TextContainer.addChild(PlayText);
			
			//this.addChild(PlayBtn);
			PlayBtn.addEventListener(MouseEvent.CLICK, PlayFunc, false, 0, true);
			
			this.addChild(ClearBtn);
			ClearBtn.addEventListener(MouseEvent.CLICK, ClearFunc, false, 0, true);
			
			this.stage.addEventListener(Event.RESIZE, Resized, false, 0, true);
			Resized();
		}
		
		public function PlayFunc(e:MouseEvent):void {
			SystemMain.instance.StateTo(new GameScreen());
		}
		
		public function ClearFunc(e:MouseEvent):void {
			Storage.Format();
		}
		
		public function Resized(e:Event = null):void {
			if (!this.stage) return;
			
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			background.x = (this.stage.stageWidth - background.width) / 2;
			background.y = (this.stage.stageHeight - background.height) / 2;
			
			//PlayBtn.x = (this.stage.stageWidth / 2) + 49;
			//PlayBtn.y = this.stage.stageHeight / 2 - 58;
			
			TextContainer.x = background.x + 448 + 261/2;
			TextContainer.y = background.y + 241;
			
			PlayText.x = -PlayText.width/2;
			PlayText.y = 5;
		}
		
		public function MouseOverText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array(new GlowFilter(0xFF0000));
			//textField.filters = new Array(new DropShadowFilter(4, 45, 0xFF0000));
		}
		
		public function MouseOutText(e:MouseEvent):void {
			var textField:TextField = e.currentTarget as TextField;
			
			textField.filters = new Array();
		}
		
	}

}