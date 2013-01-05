package LORgames.Engine 
{
	/**
	 * Logs messages to the screen, file or wherever really...
	 * @version 2
	 * @author P. Fox
	 */
	public class Logger {
		public static const MSG_INFO:int = 1;
		public static const MSG_ERROR:int = 2;
		public static const MSG_WARNING:int = 4;
		public static const MSG_ALERT:int = 8;
		public static const MSG_QUERY:int = 16;
		public static const MSG_ALL:int = MSG_INFO | MSG_ERROR | MSG_WARNING | MSG_ALERT | MSG_QUERY;
		
		private static const MSG_NAMES:Array = new Array("INFO", "ERROR", "WARNING", "ALERT", "QUERY");
		
		private static const WRITE_TO_FILE:Boolean = false;
		private static const ALWAYS_TRACE:Boolean = true;
		
		private static const ALLOW_WRITE_TO_HOOK:Boolean = false;
		private static var outputHook:Function = null;
		private static var outputHookMask:int = MSG_ALL;
		
		public static function WriteToLog(msg:String, msgType:int):void {
			if (msgType == MSG_ERROR || msgType == MSG_WARNING || msgType == MSG_ALERT || msgType == MSG_QUERY) {
				new MessageBox(msg, msgType, null, "OK");
			} 
			if (ALWAYS_TRACE) {
				trace(MSG_NAMES[Math.log(msgType) / Math.log(2)] + ": " + msg);
			}
			
			if (ALLOW_WRITE_TO_HOOK && outputHook != null && (outputHookMask & msgType) > 0) {
				outputHook(msg, msgType);
			}
			
			if (WRITE_TO_FILE) {
				//TODO: Make this actually write to the file..?
			}
		}
		
		/**
		 * Allows an external function to catch messages of the mask type...
		 * @param	e	A function that takes 2 params, the msg as a string and the message type as an int
		 * @param	mask	A bitflag mask to filter out unwanted messages
		 * @return
		 */
		public static function RegisterHook(e:Function, mask:int = 0):Boolean {
			if (!ALLOW_WRITE_TO_HOOK) return false;
			if (outputHook != null && e != null) return false;
			
			if (mask == 0) mask = MSG_ALL;
			
			outputHookMask = mask;
			outputHook = e;
			
			return true;
		}
		
	}

}