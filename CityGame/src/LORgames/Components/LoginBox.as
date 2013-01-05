package LORgames.Components 
{
	import BuildABridge.CommunicationComponents.ServerComm;
	import com.adobe.crypto.MD5;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import LORgames.Engine.Logger;
	
	/**
	 * ...
	 * @author P. Fox
	 * @version 3
	 */
	
	public class LoginBox extends Sprite {
		
		private static var hasActiveSession:Boolean = false;
		
		private var container:Sprite = new Sprite();
		
		private var header:TextField = new TextField();
		private var usernameInput:TextField = new TextField();
		private var passwordInput:TextField = new TextField();
		private var usernameLabel:TextField = new TextField();
		private var passwordLabel:TextField = new TextField();
		
		private var loginBtn:Button = new Button("Login", 85, 20);
		private var cancelBtn:Button = new Button("Cancel", 85, 20);
		
		private var OnSuccessCallback:Function = null;
		private var OnCancelCallback:Function = null;
		
		public function LoginBox(onSuccess:Function, onCancel:Function) {
			this.addEventListener(Event.ADDED_TO_STAGE, OnAdded, false, 0, true);
			
			OnSuccessCallback = onSuccess;
			OnCancelCallback = onCancel;
			
			header.defaultTextFormat = new TextFormat("Verdana", 16, 0xFFFFFF);
			header.autoSize = TextFieldAutoSize.LEFT;
			header.text = "LORgames Login";
			header.selectable = false;
			header.x = 5;
			header.y = 5;
			
			usernameLabel.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			usernameLabel.autoSize = TextFieldAutoSize.LEFT;
			usernameLabel.text = "Email: ";
			usernameLabel.selectable = false;
			usernameLabel.x = 5;
			usernameLabel.y = 30;
			
			passwordLabel.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			passwordLabel.autoSize = TextFieldAutoSize.LEFT;
			passwordLabel.text = "Password: ";
			passwordLabel.selectable = false;
			passwordLabel.x = 5;
			passwordLabel.y = 50;
			
			usernameInput.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			usernameInput.text = "";
			usernameInput.type = TextFieldType.INPUT;
			usernameInput.x = 80;
			usernameInput.y = 30;
			usernameInput.width = 115;
			usernameInput.height = 18;
			
			passwordInput.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
			passwordInput.text = "";
			passwordInput.displayAsPassword = true;
			passwordInput.type = TextFieldType.INPUT;
			passwordInput.x = 80;
			passwordInput.y = 50;
			passwordInput.width = 115;
			passwordInput.height = 18;
			
			loginBtn.x = 10;
			loginBtn.y = 75;
			
			cancelBtn.x = 100;
			cancelBtn.y = 75;
			
			container.graphics.clear();
			container.graphics.beginFill(0x303030);
			container.graphics.drawRoundRect(0, 0, 200, 100, 10);
			container.graphics.endFill();
			
			container.graphics.beginFill(0x505050);
			container.graphics.drawRoundRect(usernameInput.x, usernameInput.y, usernameInput.width, usernameInput.height, 10);
			container.graphics.drawRoundRect(passwordInput.x, passwordInput.y, passwordInput.width, passwordInput.height, 10);
			container.graphics.endFill();
			
			container.addChild(header);
			container.addChild(usernameInput);
			container.addChild(passwordInput);
			container.addChild(usernameLabel);
			container.addChild(passwordLabel);
			container.addChild(loginBtn);
			container.addChild(cancelBtn);
			
			this.addChild(container);
			
			loginBtn.addEventListener(MouseEvent.CLICK, TryLogin, false, 0, true);
			cancelBtn.addEventListener(MouseEvent.CLICK, OnCancel, false, 0, true);
		}
		
		private function TryLogin(e:* = null):void {
			if (usernameInput.text.length > 3 && passwordInput.text.length > 0) {
				loginBtn.disable();
				ServerComm.GetInstance().Login(usernameInput.text, MD5.hash(passwordInput.text), LoginReply);
			} else {
				Logger.WriteToLog("Usernames need to be more than 3 characters and passwords cannot be empty!", Logger.MSG_ERROR);
			}
		}
		
		private function LoginReply(e:Event):void {
			var data:String = (e.target as URLLoader).data;
			
			if (data == "good") {
				OnSuccess();
			} else {
				Logger.WriteToLog(data.split(":", 2)[1], Logger.MSG_ERROR);
				loginBtn.enable();
			}
		}
		
		private function OnAdded(e:Event):void {
			this.removeEventListener(Event.ADDED, OnAdded);
			
			if (ServerComm.GetInstance().HasActiveSession()) {
				OnSuccess();
			} else {
				this.stage.addEventListener(Event.RESIZE, OnResize, false, 0, true);
				OnResize();
			}
		}
		
		private function OnResize(empty:*=null):void {
			container.x = (this.stage.stageWidth - container.width) / 2;
			container.y = (this.stage.stageHeight - container.height) / 2;
			
			this.graphics.clear();
			this.graphics.beginFill(0, 0.4);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
		}
		
		private function OnSuccess():void {
			this.stage.removeEventListener(Event.RESIZE, OnResize);
			this.parent.removeChild(this);
			ServerComm.GetInstance().ActivateSession();
			OnSuccessCallback();
		}
		
		private function OnCancel(e:MouseEvent):void {
			this.stage.removeEventListener(Event.RESIZE, OnResize);
			this.parent.removeChild(this);
			OnCancelCallback();
		}
		
	}

}