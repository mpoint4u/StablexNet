package;

import openfl.display.Sprite;
import openfl.Lib;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import ru.stablex.net.SxClient;
import ru.stablex.net.MsgExtract;

/**
 * ...
 * @author pm
 */

class ClientMain extends Sprite 
{
   /**
    * member vars
    */
	
    //user instance
    public var user : TClient;
    //chat messages
    public var chat : TextField;
    //input box
    public var input : TextField;
	
	
    /**
    * Entry point
    *
    */
    static public function main() : Void {
        Lib.current.addChild(new ClientMain());
    }//function main()
	
	

	public function new():Void {
		super();
		
        //create UI
        this.createUI();

        //create socket connection with string messages
        var client = new SxClient<String>();
        //client.extract      = callback(MsgExtract.extractString, "\n");
        client.extract      = MsgExtract.extractString.bind("\n");
        client.pack         = MsgExtract.packString.bind("\n");
        client.onMessage    = this.onMessage;
        client.onConnect    = this.onConnect;
        client.onDisconnect = this.onDisconnect;

        //user instance
        this.user = {
            name  : null,
            send  : client.send,
            close : client.close
        };

        //connect to server
        client.connect('localhost', 20000);
        this.showMsg('Trying to connect...');

        //This is not required for flash target, since flash already handles socket events.
        //Does nothing for flash{
            //For other targets we need to check for socket events
            Lib.current.addEventListener(Event.ENTER_FRAME, function(e:Event){
                //if socket has events, this method will fire them
                client.processEvents();
            });		
		
		// Assets:
		// openfl.Assets.getBitmapData("img/assetname.jpg");
		
	}//function new()
	
    /**
    * Creates ui
    *
    */
    public function createUI() : Void {
        //input box
        this.input = new TextField();
        this.input.border = true;
        this.input.width  = 800;
        this.input.height = 20;
        this.input.type = TextFieldType.INPUT;
        this.addChild(this.input);

        //chat messages
        this.chat = new TextField();
        this.chat.multiline = true;
        this.chat.autoSize  = TextFieldAutoSize.LEFT;
        this.chat.y = 30;
        this.addChild(this.chat);

        //send messages on ENTER key
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent){
            //if pressed ENTER
            if( e.keyCode == 13 ) {
                //send message
                this.user.send(this.input.text);
                this.input.text = "";
            }
        });
    }//function createUI()	
	
}
