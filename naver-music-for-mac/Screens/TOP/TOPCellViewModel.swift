//
//  TOPCellViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation

class TOPCellViewModel {
  private let music: Music
  
  public let name: String
  public let albumName: String
  public let coverImageURL: URL?
  public let artistName: String
  public let rank: String

  
  init(music: Music, rank: Int?) {
    self.music = music
    
    self.name = self.music.name ?? ""
    self.albumName = self.music.album?.name ?? ""
    self.coverImageURL = self.music.album?.coverImageURL(size: .medium)
    self.artistName = self.music.artist?.name ?? ""
    if let rank = rank {
      self.rank = String(format: "%02d", rank)
    } else {
      self.rank = ""
    }
  }
}
