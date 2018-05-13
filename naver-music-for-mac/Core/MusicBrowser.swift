//
//  MusicBrowser.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

enum TOPType {
  case total
  case domestic
  case oversea
  case musician
}

protocol MusicBrowserType {
  func search(top type: TOPType) -> Single<[Music]>
}
