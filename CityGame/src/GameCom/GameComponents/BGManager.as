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
		private var layer:Sprite;
		
		// tile size in pixels
		private const TILESIZEX:int = 146;
		private const TILESIZEY:int = 146;
		
		// max number of tiles
		private var maxTilesX:int;
		private var maxTilesY:int;
		
		// number of visible tiles
		private var numTilesX:int;
		private var numTilesY:int;
		
		// map
		private var mapdata:Array = new Array();
		
		// tiles currently loaded
		private var tiles:Array = new Array();
		private var toLoad:Array = new Array();
		
		public function BGManager(worldSpr:Sprite) {
			this.layer = worldSpr;
			
			var mapfile:ByteArray = ThemeManager.Get("mapcache/maptest.map");
			
			maxTilesX = mapfile.readInt();
			maxTilesY = mapfile.readInt();
			
			for (var i:int = 0; i < maxTilesX; i++) {
				mapdata.push(new Array());
				tiles.push(new Array());
				for (var j:int = 0; j < maxTilesY; j++) {
					mapdata[i][j] = mapfile.readByte();
				}
			}
			
			numTilesX = layer.stage.stageWidth / TILESIZEX;
			numTilesY = layer.stage.stageHeight / TILESIZEY;
			
			// populate with currently visible tiles
			var tileX:int = 0;
			var tileY:int = 0;
			for (i = 0; i <= numTilesX; i++) {
				tileX = (layer.x / TILESIZEX) + i;
				for (j = 0; j <= numTilesY; j++) {
					tileY = (layer.y / TILESIZEY) + j;
					tiles[tileX][tileY] = new Bitmap(ThemeManager.Get("Tiles/" + mapdata[tileX][tileY] + ".png"));
					layer.addChild(tiles[i][j]);
					tiles[tileX][tileY].x = tileX * TILESIZEX;
					tiles[tileX][tileY].y = tileY * TILESIZEY;
				}
			}
			
			// TODO: need to add new tiles as they come into range, and clean up old tiles
			// TODO: handle tile coordinates properly (negative coordinates)
		}
		
		public function Update():void {

		}
	}

}