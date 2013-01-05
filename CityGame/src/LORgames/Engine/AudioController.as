package LORgames.Engine 
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class AudioController {
		/**
		 * Plays a sound file from a URL once
		 * @param filename the url to play the sound from
		 */
		public static function PlaySound(filename:String):void {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio) {
				//Get the sound and play it
				var s:Sound = new Sound(new URLRequest(filename();
				s.play();
			}
		}
		
	}

}