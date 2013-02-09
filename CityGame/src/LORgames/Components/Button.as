package LORgames.Components {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author PaulFox
	 * @version 3
	 * Changed to protected so can be overriden elsewhere
	 */
	public class Button extends MovieClip {
		private var tf:TextField = new TextField();
		private var m_w:int;
		private var m_h:int;
		
		public function Button(label:String = "", width:int = 100, height:int = 30) {
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat("Verdana", 10, 0xFFFFFF);
			tf.text = label;
			tf.autoSize = TextFieldAutoSize.LEFT;
			this.tabEnabled = false;
			this.addChild(tf);
			
			this.size(width, height);
			
			Prepare();
		}
		
		protected function Prepare():void {
			this.stop();
			this.buttonMode = true;
			tf.mouseEnabled = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, highlighted);
			this.addEventListener(MouseEvent.ROLL_OUT, released);
			this.addEventListener(MouseEvent.MOUSE_UP, released);
			this.addEventListener(MouseEvent.MOUSE_DOWN, clicked);
		}
		
		public function move(newX:int, newY:int):void {
			this.x = newX;
			this.y = newY;
		}
		
		public function size(newWidth:int, newHeight:int):void {
			m_w = newWidth;
			m_h = newHeight;
			
			tf.x = m_w/2 - tf.width/2;
			tf.y = m_h/2 - tf.height/2;
			
			draw();
		}
		
		public function draw(innerColour:uint = 0x303030, alpha:Number = 0.85):void {
			this.graphics.clear();
			this.graphics.beginFill(innerColour, alpha);
			this.graphics.lineStyle(0, 0xFFFFFF, 1, true);
			this.graphics.drawRect(0, 0, m_w, m_h);
			this.graphics.endFill();
		}
		
		protected function highlighted(me:MouseEvent = null):void {
			draw(0x606060, 0.85);
		}
		
		protected function released(me:MouseEvent = null):void {
			draw();
		}
		
		protected function clicked(me:MouseEvent = null):void {
			draw(0x505050, 0.3);
		}
		
		public function disable():void {
			this.mouseEnabled = false;
			this.enabled = false;
			tf.mouseEnabled = false;
		}
		
		public function enable():void {
			this.mouseEnabled = true;
			this.enabled = true;
			tf.mouseEnabled = true;
		}
		
		public function getLabel():String {
			return tf.text;
		}
		
	}

}