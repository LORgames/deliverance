package LORgames.Engine {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import LORgames.Components.Button;
	import LORgames.Components.TextBox;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class MessageBox extends Sprite {
		
		private var container:Sprite = new Sprite();
		private var text:TextBox = new TextBox();
		private var buttons:Sprite = new Sprite();
		
		private var Callback:Function = null;
		private var btnTexts:Array;
		
		public function MessageBox(msg:String, msgType:int, callback:Function = null, ...buttonText) {
			Callback = callback;
			btnTexts = buttonText;
			
			text.SetText(msg);
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
			
			Main.GetStage().addChild(this);
		}
		
		private function Init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			this.stage.addEventListener(Event.RESIZE, Resize, false, 0, true);
			
			text.SetSize(400, 200, true);
			text.Selectable(false);
			container.addChild(text);
			this.addChild(container);
			
			if (btnTexts != null) {
				for (var i:int = 0; i < btnTexts.length; i++) {
					var b:Button = new Button(btnTexts[i]);
					if(i > 0) {
						b.x = buttons.width + 10;
					}
					buttons.addChild(b);
					b.addEventListener(MouseEvent.CLICK, ClickedBtn, false, 0, true);
				}
				container.addChild(buttons);
			}
			
			Resize();
		}
		
		private function Resize(e:*= null):void {
			buttons.x = (text.width - buttons.width) / 2
			buttons.y = text.height + 10;
			
			container.x = (stage.stageWidth - container.width) / 2;
			container.y = (stage.stageHeight - container.height) / 2;
			
			this.graphics.clear();
			this.graphics.beginFill(0, 0.4);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
			
			this.graphics.beginFill(0x303030, 0.9);
			this.graphics.drawRoundRect(container.x-10, container.y-10, container.width+20, container.height+20, 10);
			this.graphics.endFill();
		}
		
		public function UpdateText(newText:String):void {
			text.SetText(newText);
			Resize();
		}
		
		public function Close():void {
			this.stage.removeEventListener(Event.RESIZE, Resize);
			this.parent.removeChild(this);
		}
		
		public function ClickedBtn(e:MouseEvent):void {
			if(Callback != null) {
				Callback((e.currentTarget as Button).getLabel());
			}
			Close();
		}
		
	}

}