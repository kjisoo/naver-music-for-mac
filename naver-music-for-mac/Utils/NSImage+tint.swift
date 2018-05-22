//
//  NSImage+tint.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 23..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

extension NSImage {
  func tint(color: NSColor) -> NSImage {
    let image = self.copy() as! NSImage
    image.lockFocus()
    color.set()
    __NSRectFillUsingOperation(NSMakeRect(0, 0, image.size.width, image.size.height), NSCompositingOperation.sourceAtop)
    image.unlockFocus()
    return image
  }
}
