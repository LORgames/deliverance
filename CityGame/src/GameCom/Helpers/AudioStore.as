package GameCom.Helpers 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AudioStore {
		[Embed(source="../../../lib/Audio/BackgroundMusic.mp3")]
		public static const Music:Class;
		
		[Embed(source="../../../lib/Audio/MachineGunFire.mp3")]
		public static const MachineGunBullet:Class;
		
		[Embed(source="../../../lib/Audio/TruckIdle2.mp3")]
		public static const TruckIdle:Class;
		
		[Embed(source = "../../../lib/Audio/TruckReverse.mp3")]
		public static const TruckReverse:Class;
		
		[Embed(source = "../../../lib/Audio/TruckDriving.mp3")]
		public static const TruckDriving:Class;
		
		[Embed(source = "../../../lib/Audio/TruckTakeoff.mp3")]
		public static const TruckTakeoff:Class;
		
		[Embed(source="../../../lib/Audio/Horn.mp3")]
		public static const Horn:Class;
		
		[Embed(source="../../../lib/Audio/NPCHitSound.mp3")]
		public static const NPCHit:Class;
		
		[Embed(source="../../../lib/Audio/Explode.mp3")]
		public static const Explode:Class;
	}

}