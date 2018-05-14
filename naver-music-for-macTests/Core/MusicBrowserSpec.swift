//
//  MusicBrowserSpec.swift
//  naver-music-for-macTests
//
//  Created by sonny on 2018. 5. 14..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Quick
import Nimble
import Moya
import RxBlocking

@testable import naver_music_for_mac

class MusicBrowserSpec: QuickSpec {
  override func spec() {
   
    var musicBrowser: MusicBrowser!
    
    context("Response success") {
      beforeEach {
        let endpointClosure = { (target: NaverPage) -> Endpoint in
          let data = (try! String(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "TOP", ofType: "html")!)).data(using: .utf8)!
          let url = URL(target: target).absoluteString
          return Endpoint(url: url,
                          sampleResponseClosure: {.networkResponse(200, data)},
                          method: target.method,
                          task: target.task,
                          httpHeaderFields: target.headers)
        }
        let stubClosure = { (target: TargetType) -> Moya.StubBehavior in
          return .immediate
        }
        let provider = MoyaProvider<NaverPage>(endpointClosure: endpointClosure, stubClosure: stubClosure)
        musicBrowser = MusicBrowser(provider: provider)
      }
      
      it("two page request and merge") {
        let musics = try? musicBrowser.search(top: .total).toBlocking().first()
        expect(musics??.count).to(equal(100))
      }
    }
    
    
    context("Response error") {
      beforeEach {
        let endpointClosure = { (target: NaverPage) -> Endpoint in
          let url = URL(target: target).absoluteString
          return Endpoint(url: url,
                          sampleResponseClosure: {.networkResponse(400, Data())},
                          method: target.method,
                          task: target.task,
                          httpHeaderFields: target.headers)
        }
        let stubClosure = { (target: TargetType) -> Moya.StubBehavior in
          return .immediate
        }
        let provider = MoyaProvider<NaverPage>(endpointClosure: endpointClosure, stubClosure:stubClosure)
        musicBrowser = MusicBrowser(provider: provider)
      }
      
      it("request failed") {
        var occurredError = false
        _ = try? musicBrowser.search(top: .total).subscribe(onSuccess: { (a) in
          fail()
        }, onError: { (e) in
          occurredError = true
        })
        expect(occurredError).toEventually(beTrue())
      }
    }
  }
}
