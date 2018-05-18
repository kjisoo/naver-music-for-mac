//
//  SignViewController.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 18..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import WebKit
class SignViewController: NSViewController {
  @IBOutlet weak var webView: WebView!
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("SignViewController")
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    self.webView.mainFrame.load(URLRequest(url: URL(string: "https://nid.naver.com/nidlogin.login?svctype=262144")!))
  }
}

extension SignViewController: WebFrameLoadDelegate {
  func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
    AuthService.shared().refresh()
  }
}
