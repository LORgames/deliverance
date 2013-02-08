package LORgames.Engine 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
		private static var loopsPlaying:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		private static var quickPlaying:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		
		//Mute bool
		private static var muted:Boolean = false;
		
		public static function GetMuted():Boolean {
			return muted;
		};
		
		public static function SetMuted(b:Boolean):void {
			muted = b;
			
			var tr:SoundTransform = new SoundTransform();
			var vol:Number = new Number(!muted);
			
			var s:SoundChannel;
			
			for each (s in loopsPlaying) {
				if (s == null) continue;
				
				tr = s.soundTransform;
				tr.volume = vol;
				s.soundTransform = tr;
			}
			
			for each (s in quickPlaying) {
				if (s == null) continue;
				
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
				channel.addEventListener(Event.SOUND_COMPLETE, soundFinished);
				
				quickPlaying.push(channel);
			}
		}
		
		public static function PlayLoop(soundCLS:Class, hasVolume:Boolean = true):SoundChannel {
			//Check that the system has the capability to play audio
			if (Capabilities.hasAudio && !GetMuted()) {
				var mySound:Sound = new soundCLS();
				var channel:SoundChannel = null;
				channel = mySound.play(0, int.MAX_VALUE, new SoundTransform((hasVolume?1:0)));
				loopsPlaying.push(channel);
				
				return channel;
			}
			
			return null;
		}
		
		public static function FadeOut(sound:SoundChannel):void {
			if (sound == null) return;
			
			var mt:SoundTransform = sound.soundTransform;
			mt.volume = 0.0;
			sound.soundTransform = mt;
		}
		
		public static function FadeIn(sound:SoundChannel):void {
			if (sound == null) return;
			if (GetMuted()) return;
			
			var mt:SoundTransform = sound.soundTransform;
			mt.volume = 1.0;
			sound.soundTransform = mt;
		}
		
		private static function soundFinished(e:Event):void {
			quickPlaying.splice(quickPlaying.indexOf(e.target), 1);
		}
		
	}

}