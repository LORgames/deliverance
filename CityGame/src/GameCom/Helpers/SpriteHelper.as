package GameCom.Helpers 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author P. Fox
	 */
	public class SpriteHelper {
		
		public static function CreateCenteredBitmap(bitmap:Bitmap):Sprite {
			var s:Sprite = new Sprite();
			s.addChild(bitmap);
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
			return s;
		}
		
		public static function CreateCenteredBitmapData(bitmapdata:BitmapData):Sprite {
			var bitmap:Bitmap = new Bitmap(bitmapdata);
			return CreateCenteredBitmap(bitmap);
		}
		
	}

}