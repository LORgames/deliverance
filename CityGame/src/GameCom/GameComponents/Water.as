package GameCom.GameComponents  {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class Water extends Sprite {
		public const SIZE_X:int = 256;//512;
		public const SIZE_Y:int = 256;//512;
		
		private var drawnLayer:Sprite = new Sprite();
		
		public const ANIMATION_SCALE:Number = 0.025;
		private var animationTick:Number = 0;
		
		private var bitmapData_1:BitmapData;
		private var bitmapData_2:BitmapData;
		private var bitmapData_3:BitmapData;
		private var bitmapData_4:BitmapData;
		
		private var speeds:Array = [];
		
		private var baseX:Number = 32;
		private var baseY:Number = 32;
		private var numOctaves:uint = 4;
		private var randomSeed:int = 1257;
		private var stitch:Boolean = true;
		private var fractalNoise:Boolean = true;
		private var channelOptions:uint = 15;// 15;
		private var grayScale:Boolean = true;
		
		public function Water() {
			bitmapData_1 = new BitmapData(SIZE_X, SIZE_Y, true);
			bitmapData_2 = new BitmapData(SIZE_X, SIZE_Y, true);
			bitmapData_3 = new BitmapData(SIZE_X, SIZE_Y, true);
			bitmapData_4 = new BitmapData(SIZE_X, SIZE_Y, true);
			
			this.addChild(drawnLayer);
			
			speeds[0] = new Point( 08,  12);
			speeds[1] = new Point( 28, -10);
			speeds[2] = new Point(-16, -24);
			speeds[3] = new Point(-14,  29); 
			
			bitmapData_1.perlinNoise(baseX, baseY, 1, randomSeed + 0, true, fractalNoise, channelOptions, grayScale);
			bitmapData_2.perlinNoise(baseX, baseY, 1, randomSeed + 1, true, fractalNoise, channelOptions, grayScale);
			bitmapData_3.perlinNoise(baseX, baseY, 1, randomSeed + 2, true, fractalNoise, channelOptions, grayScale);
			bitmapData_4.perlinNoise(baseX, baseY, 1, randomSeed + 3, true, fractalNoise, channelOptions, grayScale);
			
			bitmapData_1.colorTransform(new Rectangle(0, 0, SIZE_X, SIZE_Y), new ColorTransform(1, 1, 1, 0.10));
			bitmapData_2.colorTransform(new Rectangle(0, 0, SIZE_X, SIZE_Y), new ColorTransform(1, 1, 1, 0.10));
			bitmapData_3.colorTransform(new Rectangle(0, 0, SIZE_X, SIZE_Y), new ColorTransform(1, 1, 1, 0.10));
			bitmapData_4.colorTransform(new Rectangle(0, 0, SIZE_X, SIZE_Y), new ColorTransform(1, 1, 1, 0.10));
		}
		
		public function Update():void {
			animationTick++;
			
			if(stage != null && this.parent != null) {
				drawnLayer.graphics.clear();
				
				var m:Matrix = new Matrix();
				m.translate(Math.sin(animationTick*ANIMATION_SCALE) * speeds[0].x, Math.cos(animationTick*ANIMATION_SCALE) * speeds[0].y);
				
				drawnLayer.graphics.beginBitmapFill(bitmapData_1, m);
				drawnLayer.graphics.drawRect(-this.parent.x-20, -this.parent.y-20, stage.stageWidth+40, stage.stageHeight+40);
				drawnLayer.graphics.endFill();
				
				m.translate(Math.sin(animationTick*ANIMATION_SCALE) * speeds[1].x, Math.cos(animationTick*ANIMATION_SCALE) * speeds[1].y);
				
				drawnLayer.graphics.beginBitmapFill(bitmapData_2, m);
				drawnLayer.graphics.drawRect(-this.parent.x-20, -this.parent.y-20, stage.stageWidth+40, stage.stageHeight+40);
				drawnLayer.graphics.endFill();
				
				m.translate(Math.sin(animationTick*ANIMATION_SCALE) * speeds[2].x, Math.cos(animationTick*ANIMATION_SCALE) * speeds[2].y);
				
				drawnLayer.graphics.beginBitmapFill(bitmapData_3, m);
				drawnLayer.graphics.drawRect(-this.parent.x-20, -this.parent.y-20, stage.stageWidth+40, stage.stageHeight+40);
				drawnLayer.graphics.endFill();
				
				m.translate(Math.sin(animationTick*ANIMATION_SCALE) * speeds[3].x, Math.cos(animationTick*ANIMATION_SCALE) * speeds[3].y);
				
				drawnLayer.graphics.beginBitmapFill(bitmapData_4, m);
				drawnLayer.graphics.drawRect(-this.parent.x-20, -this.parent.y-20, stage.stageWidth+40, stage.stageHeight+40);
				drawnLayer.graphics.endFill();
			}
		}
		
	}

}