package LORgames.Engine.StatServers 
{
	
	/**
	 * ...
	 * @author Paul
	 */
	public interface IStatServer {
		function StartLevel(levelID:String):void;
		function EndLevel():void;
		function Submit(statname:String, statvalue:int):void;
	}
	
}