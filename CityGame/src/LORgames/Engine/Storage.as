package LORgames.Engine 
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	/**
	 * ...
	 * @author ...
	 */
	public class Storage {
		private static var storageObject:SharedObject = null;
		
		private static var storageArray:Array = new Array();
		private static var settingsArray:Array = new Array();
		
		private static var mb:MessageBox;
		
		private static function Initialize():void {
			storageObject = SharedObject.getLocal(Global.GAME_NAME);
			
			if (storageObject.data.D == null || !(storageObject.data.D is Array)) {
				storageArray = new Array();
			} else {
				storageArray = storageObject.data.D as Array;
			}
			
			if (storageObject.data.S == null) {
				settingsArray = new Array();
			} else {
				settingsArray = storageObject.data.S as Array;
			}
			
			if (GetAsInt("StorageRevision") != 0 && GetAsInt("StorageRevision") < Global.WipeStorageBelowRevision) {
				Storage.Format();
			}
			
			Set("StorageRevision", Global.StorageRevision);
		}
		
		public static function GetAsVoid(index:String):* {
			if(storageObject == null) Initialize();
			
			if (storageArray[index]) {
				return storageArray[index];
			}
			
			return null;
		}
		
		public static function GetAsInt(index:String, defaultValue:int = 0):int {
			if(storageObject == null) Initialize();
			
			if (storageArray[index] is int) {
				return storageArray[index];
			}
			
			return defaultValue;
		}
		
		public static function GetAsNumber(index:String, defaultValue:Number = 0):Number {
			if(storageObject == null) Initialize();
			
			if (storageArray[index] is Number) {
				return storageArray[index];
			}
			
			return defaultValue;
		}
		
		public static function GetAsBool(index:String, defaultValue:Boolean = false):Boolean {
			if(storageObject == null) Initialize();
			
			if (storageArray[index] is Boolean) {
				return storageArray[index];
			}
			
			return defaultValue;
		}
		
		public static function Set(index:String, value:*):void {
			if (storageObject == null) Initialize();
			
			storageArray[index] = value;
			
			Save();
		}

        public static function Save():void {
			if (storageObject == null) {
				return;
			}
			
			storageObject.data.D = storageArray;
			storageObject.data.S = settingsArray;
            
            var flushStatus:String = null;
			
            try {
                flushStatus = storageObject.flush(10000);
            } catch (error:Error) {
				mb = new MessageBox("An unexpected error occurred. Please reload the game.", Logger.MSG_ERROR);
            }
			
            if (flushStatus != null) {
                switch (flushStatus) {
                    case SharedObjectFlushStatus.PENDING:
						mb = new MessageBox("Requesting permission to save object...", Logger.MSG_ERROR);
                        storageObject.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                }
            }
        }
        
        private static function onFlushStatus(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "SharedObject.Flush.Success":
					mb.Close();
					mb = null;
                    break;
                case "SharedObject.Flush.Failed":
					mb.Close();
					mb = null;
                    new MessageBox("The game will now be unsaved.", Logger.MSG_ERROR, null, "OK");
                    break;
            }

            storageObject.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
		
		public static function Format():void {
			if (storageObject == null) Initialize();
			
			storageArray = new Array();
			Save();
		}
		
		public static function SaveSetting(index:String, newValue:Boolean = true):void {
			if (storageObject == null) Initialize();
			
			settingsArray[index] = newValue;
			
			Save();
		}
		
		public static function GetSetting(index:String, defaultValue:Boolean = true):Boolean {
			if(storageObject == null) Initialize();
			
			if (settingsArray[index] is Boolean) {
				return settingsArray[index];
			}
			
			return defaultValue;
		}
		
	}

}