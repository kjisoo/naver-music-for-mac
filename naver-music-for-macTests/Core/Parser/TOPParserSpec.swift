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
        
        it("entity infor") {
          let first = parser.parse(from: htmlString)[0] as! [String: Any]

          expect(first["id"] as? String).to(equal("21293002"))
          expect(first["name"] as? String).to(equal("밤 (Time for the moon night)"))
          expect((first["album"] as! [String: Any])["id"] as? String).to(equal("2450804"))
          expect((first["album"] as! [String: Any])["name"] as? String).to(equal("여자친구 The 6th Mini Album 'Time for the moon night'"))
          expect((first["artist"] as! [String: Any])["id"] as? String).to(equal("369038"))
          expect((first["artist"] as! [String: Any])["name"] as? String).to(equal("여자친구(GFRIEND)"))
        }
      }
    }
  }
}
