package GameCom.GameComponents 
{
	import Box2D.Dynamics.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Miles
	 */
	
	public class BGManager {
		private var layer:Sprite;
		private var player:Sprite;
		
		// tile size in pixels
		private const TILESIZEX:int = 146;
		private const TILESIZEY:int = 146;
		
		// max number of tiles
		private var maxTilesX:int;
		private var maxTilesY:int;
		
		// number of visible tiles
		private var numTilesX:int;
		private var numTilesY:int;
		
		/* map data loaded as a 2D array from the map file
		 * data loaded in will be an int referencing the tile to load for that coordinate
		 * 
		 * mapdata =	{{ int tilenumber, int tilenumber, int tilenumber, ... },
		 *				 { int tilenumber, int tilenumber, int tilenumber, ... },
		 *				 { int tilenumber, int tilenumber, int tilenumber, ... },
		 * 				 ... 
		 * 				}
		 */
		private var mapdata:Array = new Array();
		
		// view rect
		private var view:Rectangle = new Rectangle();
		private var oldView:Rectangle = new Rectangle();
		
		private var first:Boolean = true;
		
		//private var toLoad:Array = new Array();
		
		public function BGManager(worldSpr:Sprite, player:Sprite) {
			this.layer = worldSpr;
			this.player = player;
			
			var mapfile:ByteArray = ThemeManager.Get("mapcache/maptest.map");
			
			maxTilesX = mapfile.readInt();
			maxTilesY = mapfile.readInt();
			 
			for (var i:int = 0; i < maxTilesX; i++) {
				mapdata.push(new Array());
				for (var j:int = 0; j < maxTilesY; j++) {
					mapdata[i][j] = mapfile.readByte();
				}
			}
			
			numTilesX = layer.stage.stageWidth / TILESIZEX;
			numTilesY = layer.stage.stageHeight / TILESIZEY;
		}
		
		public function Update():void {
			// TODO: need to add new tiles as they come into range, and clean up old tiles
			// layer.removeChild(layer.getChildByName("tile-" + tileX + "-" tileY)); removes old tile
			view.x = (layer.x + player.x) - layer.stage.stageWidth/2;
			view.y = (layer.y + player.y) - layer.stage.stageHeight/2;
			view.width = layer.stage.stageWidth;
			view.height = layer.stage.stageHeight;
			
			if (first) {
				// set up tiles array
				var tileX:int = 0;
				var tileY:int = 0;
				var bmp:Bitmap;
				
				oldView.x = (layer.x + player.x) - layer.stage.stageWidth/2;
				oldView.y = (layer.y + player.y) - layer.stage.stageHeight/2;
				oldView.width = layer.stage.stageWidth;
				oldView.height = layer.stage.stageHeight;
				
				for (var i:int = 0; i <= numTilesX; i++) {
					tileX = (oldView.x / TILESIZEX) + i;
					for (var j:int = 0; j <= numTilesY; j++) {
						tileY = (oldView.y / TILESIZEY) + j;
						if (tileX >=0 && tileX <= maxTilesX && tileY >= 0 && tileY <= maxTilesY) {
							bmp = new Bitmap(ThemeManager.Get("Tiles/" + mapdata[tileX][tileY] + ".png"));
							bmp.name = "tile-" + tileX + "-" + tileY;
							bmp.x = tileX * TILESIZEX;
							bmp.y = tileY * TILESIZEY;
							layer.addChild(bmp);
						}
					}
				}
				
				first = false;
			}
			
			if (oldView.x - view.x > TILESIZEX) {
				trace("need to load X tiles! (" + (oldView.x - view.x) + ")");
				
				tileX = ((oldView.x - TILESIZEX) / TILESIZEX);
				tileY = (oldView.y / TILESIZEY);
				
				for (i = 0; i < numTilesX; i++) {
					for (j = 0; j < numTilesY; j++) {
						tileY += i;
						if (tileX >=0 && tileX <= maxTilesX && tileY >= 0 && tileY <= maxTilesY) {
							bmp = new Bitmap(ThemeManager.Get("Tiles/" + mapdata[tileX][tileY] + ".png"));
							bmp.name = "tile-" + tileX + "-" + tileY;
							bmp.x = tileX * TILESIZEX;
							bmp.y = tileY * TILESIZEY;
							layer.addChild(bmp);
						}
						
						var displayObj:DisplayObject = layer.getChildByName("tile-" + (tileX + numTilesX) + "-" + tileY);
						if (displayObj != null)
							layer.removeChild(displayObj as Bitmap);
					}
					
					oldView.x = view.x;
				}
			} else if (oldView.x - view.x < -TILESIZEX) {
				trace("need to load -X tiles! (" + (oldView.x - view.x) + ")");
				
				tileX = ((oldView.x + oldView.width) / TILESIZEX);
				tileY = (oldView.y / TILESIZEY);
				
				for (i = 0; i < numTilesX; i++) {
					for (j = 0; j < numTilesY; j++) {
						tileY += i;
						if (tileX >=0 && tileX <= maxTilesX && tileY >= 0 && tileY <= maxTilesY) {
							bmp = new Bitmap(ThemeManager.Get("Tiles/" + mapdata[tileX][tileY] + ".png"));
							bmp.name = "tile-" + tileX + "-" + tileY;
							bmp.x = tileX * TILESIZEX;
							bmp.y = tileY * TILESIZEY;
							layer.addChild(bmp);
						}
						
						var displayObj:DisplayObject = layer.getChildByName("tile-" + (tileX - numTilesX) + "-" + tileY);
						if (displayObj != null)
							layer.removeChild(displayObj as Bitmap);
					}
					
					oldView.x = view.x;
				}
			}
			
			if (oldView.y - view.y > TILESIZEY) {
				trace("need to load Y tiles! (" + (oldView.y - view.y) + ")");
				
				tileX = (oldView.x / TILESIZEX);
				tileY = ((oldView.y -TILESIZEY) / TILESIZEY);
				
				for (i = 0; i < numTilesX; i++) {
					for (j = 0; j < numTilesY; j++) {
						tileX += i;
						if (tileX >=0 && tileX < maxTilesX && tileY >= 0 && tileY < maxTilesY) {
							bmp = new Bitmap(ThemeManager.Get("Tiles/" + mapdata[tileX][tileY] + ".png"));
							bmp.name = "tile-" + tileX + "-" + tileY;
							bmp.x = tileX * TILESIZEX;
							bmp.y = tileY * TILESIZEY;
							layer.addChild(bmp);
						}
						
						var displayObj:DisplayObject = layer.getChildByName("tile-" + tileX + "-" + (tileY + numTilesY));
						if (displayObj != null)
							layer.removeChild(displayObj as Bitmap);
					}
					
					oldView.y = view.y;
				}
			} else if (oldView.y - view.y < -TILESIZEY) {
				trace("need to load -Y tiles! (" + (oldView.y - view.y) + ")");
				
				tileX = (oldView.x / TILESIZEX);
				tileY = ((oldView.y + oldView.height) / TILESIZEY);
				
				for (i = 0; i < numTilesX; i++) {
					for (j = 0; j < numTilesY; j++) {
						tileX += i;
						if (tileX >=0 && tileX < maxTilesX && tileY >= 0 && tileY < maxTilesY) {
							bmp = new Bitmap(ThemeManager.Get("Tiles/" + mapdata[tileX][tileY] + ".png"));
							bmp.name = "tile-" + tileX + "-" + tileY;
							bmp.x = tileX * TILESIZEX;
							bmp.y = tileY * TILESIZEY;
							layer.addChild(bmp);
						}
						
						var displayObj:DisplayObject = layer.getChildByName("tile-" + tileX + "-" + (tileY - numTilesY));
						if (displayObj != null)
							layer.removeChild(displayObj as Bitmap);
					}
					
					oldView.y = view.y;
				}
			}
			
			layer.graphics.clear();
			layer.graphics.lineStyle(1);
			layer.graphics.drawRect(oldView.x, oldView.y, oldView.width, oldView.height);
			layer.graphics.lineStyle(1, 0xFF0000);
			layer.graphics.drawRect(view.x, view.y, view.width, view.height);
		}
	}

}