package LORgames.Engine 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author P. Fox
	 * @version 1
	 */
	public class AudioController {
		//All sounds currently playing
		private static var nowPlaying:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		
		//Mute bool
		private static var muted:Boolean = false;
		public static function GetMuted():Boolean { return muted };
		public static function SetMuted(b:Boolean):void {
			muted = b;
			var tr:SoundTransform = new SoundTransform();
			var vol:Number = new Number(!muted);
			for each (var s:SoundChannel in nowPlaying) {
				tr = s.soundTransform;
				tr.volume = vol;
				s.soundTransform = tr;
			}
		}
		
		/**
		 * Plays a sound file from a URL once
		 * @param filename the url to play the sound from
		 */
		public static function PlaySound(soundCLS:Class):void {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio && !GetMuted()) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				channel = mySound.play();
			}
		}
		
		public static function PlayLoop(soundCLS:Class):void {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio && !GetMuted()) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				channel = mySound.play(0, int.MAX_VALUE);
				nowPlaying.push(channel);
			}
		}
		
	}

}