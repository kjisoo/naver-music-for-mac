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
import RealmSwift

@testable import naver_music_for_mac

class MusicBrowserSpec: QuickSpec {
  override func spec() {
   
    var musicBrowser: MusicBrowser!
    var provider: MoyaProvider<NaverPage>!
    var realm: Realm!
    
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
      provider = MoyaProvider<NaverPage>(endpointClosure: endpointClosure, stubClosure: stubClosure)
      realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MusicBrowserSpec"))
      try! realm.write {
        realm.deleteAll()
      }
    }
    
    context("Response success") {
      beforeEach {
        musicBrowser = MusicBrowser(provider: provider, parser: TOPParser(), realm: realm)
      }
      
      it("get playlist") {
        // Arrange
        let playList = musicBrowser.getPlayList(type: PlayListType.total)
        
        // Assert
        expect(playList.name).to(equal(PlayListType.total.rawValue))
      }
      
      it("update playlist") {
        // Arrange
        let playList = musicBrowser.getPlayList(type: PlayListType.total)
        
        // Act
        _ = try! musicBrowser.updateTOPPlayList(top: .total).toBlocking().first()
        
        // Assert
        expect(playList.musics.count).to(equal(100))
      }
      
      it("new playlist") {
        // Arrange
        let playList = musicBrowser.getPlayList(type: PlayListType.total)
        
        // Act
        let newPlayList = try! musicBrowser.updateTOPPlayList(top: .total).toBlocking().first()
        
        // Assert
        expect(playList.musics.count).to(equal(100))
        expect(newPlayList).to(equal(playList))
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
        musicBrowser = MusicBrowser(provider: provider, parser: TOPParser(), realm: realm)
      }
      
      it("request failed") {
        var occurredError = false
        _ = musicBrowser.updateTOPPlayList(top: .total).subscribe(onSuccess: { (a) in
          fail()
        }, onError: { (e) in
          occurredError = true
        })
        expect(occurredError).toEventually(beTrue())
      }
    }
    
    describe("My play list") {
      beforeEach {
        musicBrowser = MusicBrowser(provider: provider, parser: TOPParser(), realm: realm)
      }
      
      context("add music with trackid") {
        it("Id does not exist in music models") {
          // Arrange
          let playlist = musicBrowser.getPlayList(type: PlayListType.my)
          
          // Act
          musicBrowser.addMusicToMyList(trackID: "1")
          
          // Assert
          expect(playlist.musics.count).to(equal(1))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[0].name).to(beNil())
        }
        
        it("Id exist") {
          // Arrange
          let playlist = musicBrowser.getPlayList(type: PlayListType.my)
          try? realm.write {
            realm.add(Music(value: ["id": "1", "name": "name"]))
          }
          
          // Act
          musicBrowser.addMusicToMyList(trackID: "1")
          
          // Assert
          expect(playlist.musics.count).to(equal(1))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[0].name).to(equal("name"))
        }
        
        it("add sequence") {
          // Arrange
          let playlist = musicBrowser.getPlayList(type: PlayListType.my)
          
          // Act
          musicBrowser.addMusicToMyList(trackIDs: ["1", "1", "2"])
          
          // Assert
          expect(playlist.musics.count).to(equal(3))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[1].id).to(equal("1"))
          expect(playlist.musics[2].id).to(equal("2"))
        }
      }
    }
  }
}
