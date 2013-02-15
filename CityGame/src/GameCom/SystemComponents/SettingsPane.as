package GameCom.SystemComponents {
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameCom.Managers.ScenicManager;
	import LORgames.Engine.AudioController;
	import LORgames.Engine.Storage;
	/**
	 * ...
	 * @author Paul
	 */
	public class SettingsPane extends Sprite {
		
		private var SettingsHeaderTF:TextField;
		
		private var DriveOnLeftLabel:TextField;
		private var DriveOnLeftText:TextField;
		private var DriveOnRightText:TextField;
		
		private var SoundOnLabel:TextField;
		private var SoundOnText:TextField;
		private var SoundOffText:TextField;
		
		private var QualityLabel:TextField;
		private var QualityHighText:TextField;
		private var QualityLowText:TextField;
		
		private const PANE_HEIGHT:int = 200;
		
		public function SettingsPane() {
			this.graphics.beginFill(0x0, 0.7);
			this.graphics.lineStyle(2);
			
			this.graphics.drawRoundRect(0, 0, 274, PANE_HEIGHT, 20);
			this.graphics.endFill();
			
			SettingsHeaderTF = GenerateTextfield(36, "Settings", [new GlowFilter(0x337C8C, 1, 10, 10, 5, 1)], true, -20);
			
			////////////////////////// DRIVING DIRECTION
			Global.DriveOnLeft = Storage.GetSetting("DriveOnLeft");
			
			DriveOnLeftLabel = GenerateTextfield(18, "What side do you drive on?", [], true, 30);
			
			DriveOnLeftText = GenerateTextfield(16, "Left", [], true, 55);
			DriveOnLeftText.x = 274 / 2 - DriveOnLeftText.width - 10;
			FilterSetting(DriveOnLeftText, Global.DriveOnLeft);
			GenerateListeners(DriveOnLeftText, LeftMouseOver, LeftMouseClick, LeftMouseLeave);
			
			DriveOnRightText = GenerateTextfield(16, "Right", [], true, 55);
			DriveOnRightText.x = 274 / 2 + 10;
			FilterSetting(DriveOnRightText, !Global.DriveOnLeft);
			GenerateListeners(DriveOnRightText, RightMouseOver, RightMouseClick, RightMouseLeave);
			
			/////////////////////////// SOUND
			AudioController.SetMuted(Storage.GetSetting("isMuted"));
			
			SoundOnLabel = GenerateTextfield(18, "Sound on or off?", [], true, 90);
			
			SoundOnText = GenerateTextfield(16, "On", [], true, 115);
			SoundOnText.x = 274 / 2 - SoundOnText.width - 10;
			FilterSetting(SoundOnText, !AudioController.GetMuted());
			GenerateListeners(SoundOnText, SoundOnMouseOver, SoundOnMouseClick, SoundOnMouseLeave);
			
			SoundOffText = GenerateTextfield(16, "Off", [], true, 115);
			SoundOffText.x = 274 / 2 + 10;
			FilterSetting(SoundOffText, AudioController.GetMuted());
			GenerateListeners(SoundOffText, SoundOffMouseOver, SoundOffMouseClick, SoundOffMouseLeave);
			
			////////////////////////// QUALITY
			Global.HIGH_QUALITY = Storage.GetSetting("HighQuality");
			
			if (!Global.HIGH_QUALITY) {
				ScenicManager.UpdateQuality(true);
				Main.GetStage().quality = StageQuality.LOW;
			} else {
				Main.GetStage().quality = StageQuality.HIGH;
			}
			
			QualityLabel = GenerateTextfield(18, "Visual Quality?", [], true, 150);
			
			QualityLowText = GenerateTextfield(16, "Low", [], true, 175);
			QualityLowText.x = 274 / 2 - QualityLowText.width - 10;
			FilterSetting(QualityLowText, !Global.HIGH_QUALITY);
			GenerateListeners(QualityLowText, QualityLowMouseOver, QualityLowMouseClick, QualityLowMouseLeave);
			
			QualityHighText = GenerateTextfield(16, "High", [], true, 175);
			QualityHighText.x = 274 / 2 + 10;
			FilterSetting(QualityHighText, Global.HIGH_QUALITY);
			GenerateListeners(QualityHighText, QualityHighMouseOver, QualityHighMouseClick, QualityHighMouseLeave);
		}
		
		private function GenerateTextfield(size:int, text:String, filters:Array = null, center:Boolean = true, yPos:int = 0):TextField {
			var tf:TextField = new TextField();
			
			tf.selectable = false;
			tf.defaultTextFormat = new TextFormat("Verdana", size, 0xFFFFFF);
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = text;
			tf.filters = filters;
			
			if (center) {
				tf.x = (274 - tf.width) / 2;
			}
			
			tf.y = yPos;
			
			this.addChild(tf);
			
			return tf;
		}
		
		private function FilterSetting(tf:TextField, isOn:Boolean):void {
			if (!isOn) tf.filters = [];
			else tf.filters = [new GlowFilter(0x337C8C, 1, 10, 10, 5, 1)];
		}
		
		private function GenerateListeners(tf:TextField, mouseOver:Function, clickFunc:Function, mouseLeave:Function):void {
			tf.addEventListener(MouseEvent.CLICK, clickFunc, false, 0, true);
			tf.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			tf.addEventListener(MouseEvent.ROLL_OUT, mouseLeave, false, 0, true);
		}
		
		private function LeftMouseOver(me:MouseEvent):void { if (!Global.DriveOnLeft) DriveOnLeftText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function LeftMouseClick(me:MouseEvent):void { if (!Global.DriveOnLeft) { Global.DriveOnLeft = true; Storage.SaveSetting("DriveOnLeft", true); FilterSetting(DriveOnLeftText, true); FilterSetting(DriveOnRightText, false); } }
		private function LeftMouseLeave(me:MouseEvent):void { if (!Global.DriveOnLeft) DriveOnLeftText.filters = []; }
		
		private function RightMouseOver(me:MouseEvent):void { if (Global.DriveOnLeft) DriveOnRightText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function RightMouseClick(me:MouseEvent):void { if (Global.DriveOnLeft) { Global.DriveOnLeft = false; Storage.SaveSetting("DriveOnLeft", false); FilterSetting(DriveOnLeftText, false); FilterSetting(DriveOnRightText, true);} }
		private function RightMouseLeave(me:MouseEvent):void { if (Global.DriveOnLeft) DriveOnRightText.filters = []; }
		
		private function SoundOnMouseOver(me:MouseEvent):void { if (AudioController.GetMuted()) SoundOnText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function SoundOnMouseClick(me:MouseEvent):void { if (AudioController.GetMuted()) { AudioController.SetMuted(false); Storage.SaveSetting("isMuted", false); FilterSetting(SoundOnText, true); FilterSetting(SoundOffText, false);} }
		private function SoundOnMouseLeave(me:MouseEvent):void { if (AudioController.GetMuted()) SoundOnText.filters = []; }
		
		private function SoundOffMouseOver(me:MouseEvent):void { if (!AudioController.GetMuted()) SoundOffText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function SoundOffMouseClick(me:MouseEvent):void { if (!AudioController.GetMuted()) { AudioController.SetMuted(true); Storage.SaveSetting("isMuted", true); FilterSetting(SoundOffText, true); FilterSetting(SoundOnText, false);} }
		private function SoundOffMouseLeave(me:MouseEvent):void { if (!AudioController.GetMuted()) SoundOffText.filters = []; }
		
		private function QualityLowMouseOver(me:MouseEvent):void  { if (Global.HIGH_QUALITY) QualityLowText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function QualityLowMouseLeave(me:MouseEvent):void { if (Global.HIGH_QUALITY) QualityLowText.filters = []; }
		
		private function QualityHighMouseOver(me:MouseEvent):void  { if (!Global.HIGH_QUALITY) QualityHighText.filters = [new GlowFilter(0x7C8C33, 1, 10, 10, 5, 1)]; }
		private function QualityHighMouseLeave(me:MouseEvent):void { if (!Global.HIGH_QUALITY) QualityHighText.filters = []; }
		
		private function QualityLowMouseClick(me:MouseEvent):void {
			if (Global.HIGH_QUALITY) {
				Global.HIGH_QUALITY = false;
				Storage.SaveSetting("HighQuality", false);
				
				FilterSetting(QualityHighText, false);
				FilterSetting(QualityLowText, true);
				
				ScenicManager.UpdateQuality(true);
				Main.GetStage().quality = StageQuality.LOW;
			}
		}
		
		private function QualityHighMouseClick(me:MouseEvent):void {
			if (!Global.HIGH_QUALITY) {
				Global.HIGH_QUALITY = true;
				Storage.SaveSetting("HighQuality", true);
				
				FilterSetting(QualityHighText, true);
				FilterSetting(QualityLowText, false);
				
				ScenicManager.UpdateQuality(false);
				Main.GetStage().quality = StageQuality.HIGH;
			}
		}
		
	}

}