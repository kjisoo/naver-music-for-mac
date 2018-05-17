//
//  PlayListSpec.swift
//  naver-music-for-macTests
//
//  Created by sonny on 2018. 5. 17..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Quick
import Nimble
import Swinject
import RealmSwift

@testable import naver_music_for_mac

class PlayListSpec: QuickSpec {
  override func spec() {
    beforeSuite {
      let container = Swinject.Container()
      container.register(Realm.self) { _ in
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "AlbumSpec"))
        return realm
      }
      Container.container = container
    }
    
    beforeEach {
      let realm = Container.container.resolve(Realm.self)
      try? realm?.write {
        realm?.deleteAll()
      }
    }
    
    it("get playlist") {
      // Arrange
      let playList = Playlist.get(type: .total)
      
      // Assert
      expect(playList.name).to(equal(PlayListType.total.rawValue))
    }
    
    describe("Add playlist") {
      context("using musicID") {
        it("Id does not exist in music models") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          
          // Act
          playlist.append(musicID: "1")
          
          // Assert
          expect(playlist.musics.count).to(equal(1))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[0].name).to(beNil())
        }
        
        it("Id exist") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          try? Music.realm.write {
            Music.realm.create(Music.self, value: ["id": "1", "name": "name"], update: true)
          }

          // Act
          playlist.append(musicID: "1")
          
          // Assert
          expect(playlist.musics.count).to(equal(1))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[0].name).to(equal("name"))
        }
        
        it("add sequence") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          
          // Act
          playlist.append(musicIDs: ["1", "2", "3"])
          
          // Assert
          expect(playlist.musics.count).to(equal(3))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[1].id).to(equal("2"))
          expect(playlist.musics[2].id).to(equal("3"))
        }
        
        it("add duplicated sequence") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          
          // Act
          playlist.append(musicIDs: ["1", "2", "1"])
          
          // Assert
          expect(playlist.musics.count).to(equal(3))
          expect(playlist.musics[0].id).to(equal("1"))
          expect(playlist.musics[1].id).to(equal("2"))
          expect(playlist.musics[2].id).to(equal("1"))
        }
      }
      
      context("using Music") {
      }
    }
    
    describe("Remove") {
      context("using MusicID") {
        it("remove one") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          playlist.append(musicID: "1")
          playlist.append(musicID: "2")
          
          // Act
          playlist.remove(at: 0)
          
          // Assert
          expect(playlist.musics.count).to(equal(1))
          expect(playlist.musics[0].id).to(equal("2"))
        }
        
        it("remove out of index") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          playlist.append(musicID: "1")
          
          // Act
          playlist.remove(at: 1)
          
          // Assert
          expect(playlist.musics.count).to(equal(1))
        }
        
        it("remove sequence") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          playlist.append(musicID: "1")
          playlist.append(musicID: "2")
          
          // Act
          playlist.remove(at: [0, 1])
          
          // Assert
          expect(playlist.musics.count).to(equal(0))
        }
        
        it("remove sequence") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          playlist.append(musicIDs: ["0", "1", "2", "3", "4"])
          
          // Act
          playlist.remove(at: [3, 1, 2])
          
          // Assert
          expect(playlist.musics.count).to(equal(2))
          expect(playlist.musics[0].id).to(equal("0"))
          expect(playlist.musics[1].id).to(equal("4"))
        }
        
        it("remove sequence out of range") {
          // Arrange
          let playlist = Playlist.get(type: .my)
          playlist.append(musicID: "1")
          
          // Act
          playlist.remove(at: [0, 1, 2])
          
          // Assert
          expect(playlist.musics.count).to(equal(0))
        }
      }
    }
  }
}
