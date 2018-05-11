//
//  PlayerController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class PlayerController: SplitViewController {
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupSplitView()
  }
  
  // MARK: Private methods
  private func setupSplitView() {
    let playListSplitViewItem = NSSplitViewItem(viewController: PlayListViewController())
    playListSplitViewItem.minimumThickness = 200
    self.addSplitViewItem(playListSplitViewItem)
    
    let musicCoverSplitViewItem = NSSplitViewItem(sidebarWithViewController: MusicCoverViewController())
    musicCoverSplitViewItem.maximumThickness = 300
    self.addSplitViewItem(musicCoverSplitViewItem)
  }
 
  override func splitViewDidResizeSubviews(_ notification: Notification) {
    super.splitViewDidResizeSubviews(notification)
    self.splitViewItems[1].isCollapsed = self.view.frame.width < 550
  }
}
