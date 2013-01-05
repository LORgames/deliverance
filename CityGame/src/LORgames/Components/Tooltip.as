package LORgames.Components 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class Tooltip extends Sprite {
		
		private const ROUNDNESS:Number = 5;
		private const ARROWWIDTH:Number = 20;
		private const ARROWHEIGHT:Number = 15;
		
		public static const DOWN:int = 0;
		public static const UP:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 3;
		
		private var text:TextField = new TextField();
		private var floatingDistance:Number;
		private var maxWidth:Number;
		private var floatingDirection:int;
		
		
		public function Tooltip(str:String = "", direction:int = UP, distance:Number = 25, maxWidth:Number = 250) {
			this.addChild(text);
			this.mouseEnabled = false;
			text.mouseEnabled = false;
			
			this.floatingDistance = distance;
			floatingDirection = direction;
			
			text.defaultTextFormat = new TextFormat("Verdana", 10 * Global.UI_SCALE, 0xFFFFFF);
			text.wordWrap = true;
			text.multiline = true;
			text.selectable = false;
			text.autoSize = TextFieldAutoSize.CENTER;
			
			InternalSetMaxWidth(maxWidth, false);
			SetText(str);
		}
		
		private function InternalSetMaxWidth(width:Number, redraw:Boolean):void {
			maxWidth = width;
			
			text.width = width;
			
			if (text.textWidth+ROUNDNESS < width) {
				text.width = text.textWidth + ROUNDNESS;
			}
			
			if(redraw) {
				Redraw();
			}
		}
		
		public function SetMaxWidth(width:Number):void {
			InternalSetMaxWidth(width, true);
		}
		
		public function SetText(str:String):void {
			text.text = str;
			
			InternalSetMaxWidth(maxWidth, false);
			text.height = text.textHeight;
			
			Redraw();
		}
		
		public function ChangeDirection(newDirection:int):void {
			floatingDirection = newDirection;
			InternalSetMaxWidth(maxWidth, true);
		}
		
		private function Redraw():void {
			this.graphics.clear();
			
			this.graphics.beginFill(0x202020, 0.95);
			
			if(floatingDirection == UP) {
				text.x = -text.width / 2;
				text.y = -(text.height + floatingDistance + ROUNDNESS);
				
				this.graphics.moveTo( -ARROWWIDTH / 2, -floatingDistance);
				this.graphics.lineTo( 0, ARROWHEIGHT-floatingDistance);
				this.graphics.lineTo( ARROWWIDTH / 2, -floatingDistance);
				this.graphics.lineTo( -ARROWWIDTH / 2, -floatingDistance);
			} else if(floatingDirection == DOWN) {
				text.x = -text.width / 2;
				text.y = (floatingDistance + ROUNDNESS);
				
				this.graphics.moveTo( -ARROWWIDTH / 2, floatingDistance);
				this.graphics.lineTo( 0, -ARROWHEIGHT+floatingDistance);
				this.graphics.lineTo( ARROWWIDTH / 2, floatingDistance);
				this.graphics.lineTo( -ARROWWIDTH / 2, floatingDistance);
			} else if(floatingDirection == LEFT) {
				text.x = -(text.width + floatingDistance + ROUNDNESS);
				text.y = -text.height / 2;
				
				this.graphics.moveTo( -floatingDistance, -ARROWWIDTH / 2);
				this.graphics.lineTo( ARROWHEIGHT-floatingDistance, 0);
				this.graphics.lineTo( -floatingDistance, ARROWWIDTH / 2);
				this.graphics.lineTo( -floatingDistance, -ARROWWIDTH / 2);
			} else if(floatingDirection == RIGHT) {
				text.x = (floatingDistance + ROUNDNESS);
				text.y = -text.height / 2;
				
				this.graphics.moveTo( floatingDistance, -ARROWWIDTH / 2);
				this.graphics.lineTo( floatingDistance-ARROWHEIGHT, 0);
				this.graphics.lineTo( floatingDistance, ARROWWIDTH / 2);
				this.graphics.lineTo( floatingDistance, -ARROWWIDTH / 2);
			}
			
			this.graphics.drawRoundRect(text.x - ROUNDNESS, text.y - ROUNDNESS, text.width + 2 * ROUNDNESS, text.height + 2 * ROUNDNESS, ROUNDNESS);
			this.graphics.endFill();
		}
		
	}

}