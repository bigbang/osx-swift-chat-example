//
//  Extensions.swift
//  HelloChat-OSX
//

import Foundation
import Cocoa

extension NSTextView {
    func appendText(line: String) {
        let attrDict = [NSFontAttributeName: NSFont.systemFontOfSize(18.0)]
        let astring = NSAttributedString(string: "\(line)\n", attributes: attrDict)
        self.textStorage?.appendAttributedString(astring)
        let loc = self.string?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        let range = NSRange(location: loc!, length: 0)
        self.scrollRangeToVisible(range)
    }
}

func xlog(logView:NSTextView?, line:String) {
    if let view = logView {
        view.appendText(line)
    }
}
