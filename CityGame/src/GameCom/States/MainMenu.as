package GameCom.States {
	import GameCom.SystemMain;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
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
		
		private var PlayBtn:Button = new Button(Strings.Get("PlayGame"), 200, 50);
		private var ClearBtn:Button = new Button("CLEAR SAVE");
		
		public function MainMenu() {			
			//Just make sure we're ready to do this...
			if (this.stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
		}
		
		public function Init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			background = new Bitmap(ThemeManager.Get("Backgrounds/Menu.jpg"));
			
			//Start Menu
			this.addChild(background);
			
			this.addChild(PlayBtn);
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
			
			background.x = (this.stage.stageWidth - background.width) / 2;
			background.y = 50;
			
			PlayBtn.x = (this.stage.stageWidth - PlayBtn.width) / 2;
			PlayBtn.y = this.stage.stageHeight - 75;
		}
		
	}

}