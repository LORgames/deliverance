package LORgames.Engine 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
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
		public static function PlaySound(soundCLS:Class):void {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				channel = mySound.play();
			}
		}
		
		public static function PlayLoop(soundCLS:Class):void {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				channel = mySound.play(0, int.MAX_VALUE);
				
			}
		}
		
	}

}