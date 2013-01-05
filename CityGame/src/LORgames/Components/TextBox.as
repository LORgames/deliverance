package LORgames.Components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author P. Fox
	 * @version 2
	 */
	public class TextBox extends Sprite {
		
		private var _width:Number = 100;
		private var _height:Number = 200;
		
		//The drawing system
		private var text:TextField = new TextField();
		private var scroll:ScrollBar = new ScrollBar(_height, OnScroll);
		
		public function TextBox() {
			text.selectable = false;
			text.defaultTextFormat = new TextFormat("Arial", 14 * Global.UI_SCALE, 0x000000);
			text.wordWrap = true;
			text.multiline = true;
			text.mouseEnabled = true;
			text.mouseWheelEnabled = true;
			
			this.addChild(text);
			this.addChild(scroll);
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL, OnScrollMouse, false, 0, true);
			text.addEventListener(Event.CHANGE, OnChange, false, 0, true);
			
			SetSize(_width, _height);
		}
		
		public function Selectable(isSelectable:Boolean):void {
			text.selectable = isSelectable;
		}
		
		public function InputText(isInputable:Boolean):void {
			if (isInputable) {
				text.type = TextFieldType.INPUT;
			} else {
				text.type = TextFieldType.DYNAMIC;
			}
		}
		
		public function SetSize(width:Number, height:Number, transparent:Boolean = false):void {
			_width = width;
			_height = height;
			
			scroll.Resize(height, 15);
			scroll.x = width - scroll.width;
			
			text.width = width - scroll.width;
			text.height = height;
			
			this.graphics.clear();
			
			if(!transparent) {
				this.graphics.beginFill(0x80C0FF, 0.95);
				text.textColor = 0x000000;
			} else {
				this.graphics.beginFill(0x80C0FF, 0.15);
				text.textColor = 0xFFFFFF;
			}
			
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			
			OnScroll();
			CheckShowScroll();
		}
		
		private function OnScroll():void {
			var cX:Number = scroll.GetPosition();
			
			text.scrollV = text.maxScrollV * cX;
		}
		
		private function CheckShowScroll():void {
			if (text.textHeight > text.height) {
				scroll.visible = true;
			} else {
				scroll.visible = false;
			}
		}
		
		private function OnChange(e:*= null):void {
			CheckShowScroll();
		}
		
		private function OnScrollMouse(e:MouseEvent):void {
			scroll.SetPosition(text.scrollV / text.maxScrollV);
		}
		
		public function SetText(innerText:String):void {
			text.htmlText = innerText;
			OnScroll();
			CheckShowScroll();
		}
		
		public function GetText():String {
			return text.text;
		}
		
	}

}