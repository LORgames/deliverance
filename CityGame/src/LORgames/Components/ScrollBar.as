package LORgames.Components {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author PaulFox
	 * @version 3
	 */
	public class ScrollBar extends MovieClip {
		private var position:Number;
		private var scroll_height:Number = 0;
		
		private var updated:Function;
		
		private var cur_height:Number;
		private var cur_width:Number;
		
		private var doScroll:Boolean = false;
		
		public function ScrollBar(height:Number, onUpdate:Function) {
			this.cur_height = height;
			this.cur_width = 30;
			scroll_height = 30;
			
			this.updated = onUpdate;
			this.position = 0.0;
			
			this.addEventListener(MouseEvent.CLICK, MoveMe);
			this.addEventListener(MouseEvent.MOUSE_DOWN, StartMe);
			this.addEventListener(MouseEvent.MOUSE_UP, StopMe);
			this.addEventListener(MouseEvent.MOUSE_MOVE, MoveMe);
			
			UpdatePosition();
		}
		
		private function StartMe(me:MouseEvent):void {
			doScroll = true;
		}
		
		private function StopMe(me:MouseEvent):void {
			doScroll = false;
		}
		
		private function MoveMe(me:MouseEvent):void {
			if (me.type == MouseEvent.MOUSE_MOVE && !doScroll) {
				return void;
			}
			if (me.localY > scroll_height / 2 && me.localY < cur_height - scroll_height / 2) {
				if ((me.localY - scroll_height / 2) / (cur_height - scroll_height) < 0.01) {
					this.position = 0;
				} else if ((me.localY - scroll_height / 2) / (cur_height - scroll_height) > 0.99) {
					this.position = 1;
				} else {
					this.position = (me.localY - scroll_height / 2) / (cur_height - scroll_height);
				}
				
				updated();
				UpdatePosition();
			}
		}
		
		public function GetPosition():Number {
			return position;
		}
		
		public function SetPosition(newPosition:Number):void {
			if (newPosition >= 0 && newPosition <= 1) {
				position = newPosition;
			}
			
			UpdatePosition();
		}
		
		public function SetPositionEx(newStartPosition:Number, newEndPosition:Number):void {
			scroll_height = newEndPosition - newStartPosition;
			SetPosition(newStartPosition);
		}
		
		public function Resize(newHeight:Number, newWidth:Number):void {
			cur_height = newHeight;
			cur_width = newWidth;
			
			UpdatePosition();
		}
		
		private function UpdatePosition():void {
			this.graphics.clear();
			
			this.graphics.beginFill(0x404040, 0.75);
			this.graphics.drawRect(0, 0, cur_width, cur_height);
			this.graphics.endFill();
			
			var c:Number = (cur_height - scroll_height) * position
			
			this.graphics.beginFill(0x707070);
			this.graphics.drawRect(0, c, cur_width, scroll_height);
			this.graphics.endFill();
		}
		
	}

}