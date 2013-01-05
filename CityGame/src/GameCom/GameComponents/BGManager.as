package GameCom.GameComponents 
{
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Miles
	 */
	
	public class BGManager 
	{
		// in image files
		// ground = base
		// roof = ceil
		
		// bgType will be "base" or "ceil"
		private var bgType:String;
		
		// tile size in pixels
		private const TILESIZEX:int = 1024;
		private const TILESIZEY:int = 1024;
		
		// max number of tiles
		private const MAXTILEX:int = 16;
		private const MAXTILEY:int = 16;
		
		public function BGManager(bgType:String, worldSpr:Sprite) 
		{
			this.bgType = bgType;
			
			var grtyu:ByteArray = ThemeManager.Get("mapcache/base_0_0.png");
			
			var ldr:Loader = new Loader();
			ldr.loadBytes(grtyu);
			
			worldSpr.addChild(ldr);
		}
		
	}

}