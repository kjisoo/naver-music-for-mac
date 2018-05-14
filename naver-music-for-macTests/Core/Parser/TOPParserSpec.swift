//
//  TOPParserSpec.swift
//  naver-music-for-macTests
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//


import Quick
import Nimble

@testable import naver_music_for_mac

class TOPParserSpec: QuickSpec {
  override func spec() {
    
    describe("parsing") {
      var parser: TOPParser!
      var htmlString: String!
      beforeEach {
        htmlString = try! String(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "TOP", ofType: "html")!)
        parser = TOPParser()
      }
      
      context("success") {
        it("count") {
          let result = parser.parse(from: htmlString)
          expect(result.count).to(equal(50))
        }
        
        it("relation") {
          let first = parser.parse(from: htmlString)[0]
          expect(first.album).notTo(beNil())
          expect(first.artist).notTo(beNil())
          expect(first.music.album).to(equal(first.album))
          expect(first.music.artist).to(equal(first.artist))
          expect(first.album?.artist).to(equal(first.artist))
        }
        
        it("entity infor") {
          let first = parser.parse(from: htmlString)[0]
          expect(first.music.id).to(equal("21293002"))
          expect(first.music.name).to(equal("밤 (Time for the moon night)"))
          expect(first.album!.id).to(equal("2450804"))
          expect(first.album!.name).to(equal("여자친구 The 6th Mini Album 'Time for the moon night'"))
          expect(first.artist!.id).to(equal("369038"))
          expect(first.artist!.name).to(equal("여자친구(GFRIEND)"))
        }
      }
    }
  }
}
