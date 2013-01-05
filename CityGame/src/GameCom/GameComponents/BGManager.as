package GameCom.GameComponents 
{
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Miles
	 */
	
	public class BGManager {
		// in image files
		// ground = base
		// roof = ceil
		
		// bgType will be "base" or "ceil"
		private var bgType:String;
		private var layer:Sprite;
		
		// tile size in pixels
		private const TILESIZEX:int = 1024;
		private const TILESIZEY:int = 1024;
		
		// max number of tiles
		private const MAXTILEX:int = 16;
		private const MAXTILEY:int = 16;
		
		// the currently loaded bits
		private var chunks:Array = new Array();
		
		//Loading things
		private var ldr:Loader = new Loader();
		private var reqLoad:Array = new Array();
		private var currentlyLoading:Array = null;
		
		public function BGManager(bgType:String, worldSpr:Sprite) {
			this.bgType = bgType;
			this.layer = worldSpr;
			
			reqLoad.push(new Array(0, 0));
			reqLoad.push(new Array(1, 0));
			reqLoad.push(new Array(0, 1));
			reqLoad.push(new Array(1, 1));
			
			var ldr:Loader = new Loader();
			
			LoadNext();
			
			worldSpr.addChild(ldr);
		}
		
		private function LoadNext():void {
			if (currentlyLoading == null && reqLoad.length > 0) {
				currentlyLoading = (reqLoad.pop() as Array);
				
				var loadedBytes:ByteArray = ThemeManager.Get("mapcache/" + bgType + "_" + currentlyLoading[0] + "_" + currentlyLoading[1] + ".png");
				ldr.loadBytes(loadedBytes);
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoad);
			}
		}
		
		private function completedLoad(e:Event):void {
			if (currentlyLoading != null) {
				chunks[currentlyLoading[0] + "_" + currentlyLoading[1]] = e.target.loader.content;
				(chunks[currentlyLoading[0] + "_" + currentlyLoading[1]] as DisplayObject).x = TILESIZEX * currentlyLoading[0];
				(chunks[currentlyLoading[0] + "_" + currentlyLoading[1]] as DisplayObject).y = TILESIZEY * currentlyLoading[1];
				
				layer.addChild(chunks[currentlyLoading[0] + "_" + currentlyLoading[1]]);
				
				currentlyLoading = null;
			}
			
			LoadNext();
		}
	}

}