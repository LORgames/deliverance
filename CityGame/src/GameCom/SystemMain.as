package GameCom {
	import GameCom.States.*;
	import flash.display.Sprite;
	import LORgames.Localization.Strings;
	
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class SystemMain extends Sprite {
		
		public static var instance:SystemMain = null;
		
		private var contentLayer:Sprite = new Sprite();
		
		public function SystemMain() {
			if (instance != null) throw Error("There is already a game running!");
			instance = this;
			
			Strings.FillWithDefaultValues();
			
			this.addChild(contentLayer);
			
			contentLayer.addChild(new MainMenu());
		}
		
		public function StateTo(xx:Sprite):void {
			while (contentLayer.numChildren > 0) { contentLayer.removeChildAt(0); }
			contentLayer.addChild(xx);
		}
	}

}