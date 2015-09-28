//
//  ViewController.swift
//  HelloChat-OSX
//
//

import Cocoa
import BigBang
import SwiftyJSON

class ViewController: NSViewController {
    
    @IBOutlet weak var chatInput: NSTextField!
    @IBOutlet weak var chatButton: NSButton!
    @IBOutlet var chatText: NSTextView!
    
    var client: BigBangClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = DefaultBigBangClient(appURL: "https://demo.bigbang.io");
        client.connect { (err) -> Void in
            if let connectError = err {
                self.chatText.appendText("Connection error "  + connectError )
            }
            else {
                self.client.subscribe("helloChat", callback: { (serr, c) -> Void in
                    
                    if let subscribeError = serr {
                        self.chatText.appendText("Subscribe error "  + subscribeError )
                    }
                    else {
                        if  let channel = c {
                            channel.onMessage( self.onMessage )
                            channel.onJoin( self.onJoin )
                            channel.onLeave( self.onLeave )
                            self.chatText.appendText("Subscribed!")
                        }
                    }
                })
            }
        }
    }
    
    private func onMessage( msg:ChannelMessage) {
        let json = msg.payload.getBytesAsJson();
        chatText.appendText(json["msg"].string!);
    }
    
    private func onJoin( joined:String ) {
        let msg = joined + " joined."
        chatText.appendText(msg)
    }
    
    private func onLeave( left:String ) {
        let msg = left + " left."
        chatText.appendText(msg);
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func onClick(sender: AnyObject) {
        let msgText = chatInput.stringValue
        
        if( !msgText.isEmpty) {
            var msg = JSON.newJSONObject()
            msg["msg"].string  = msgText
            
            client.getChannel("helloChat")?.publish(msg)
            chatInput.stringValue = ""
        }
    }
}

