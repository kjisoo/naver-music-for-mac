//
//  AlbumSpec.swift
//  naver-music-for-macTests
//
//  Created by A on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Quick
import Nimble
import RealmSwift

@testable import naver_music_for_mac

class AlbumSpec: QuickSpec {
  override func spec() {
    beforeSuite {
      Realm.Configuration.defaultConfiguration = Realm.Configuration(inMemoryIdentifier: "AlbumSpec")
    }
    
    context("Cover image url by id") {
      it("id of album is empty") {
        let album = Album()
        
        expect(album.coverImageURL(size: .small)).to(beNil())
      }
      
      it("length of id is six") {
        let album = Album()
        album.id = "123456"
        
        expect(album.coverImageURL(size: .small)!).to(equal(URL(string: "http://musicmeta.phinf.naver.net/album/000/123/123456.jpg?type=r32Fll")))
      }
      
      it("length of id is seven") {
        let album = Album()
        album.id = "1234567"
        
        expect(album.coverImageURL(size: .small)!).to(equal(URL(string: "http://musicmeta.phinf.naver.net/album/001/234/1234567.jpg?type=r32Fll")))
      }
    }
    
    context("size of cover image") {
      it("small") {
        let album = Album()
        album.id = "123456"
        
        expect(album.coverImageURL(size: .small)!).to(equal(URL(string: "http://musicmeta.phinf.naver.net/album/000/123/123456.jpg?type=r32Fll")))
      }
      
      it("medium") {
        let album = Album()
        album.id = "123456"
        
        expect(album.coverImageURL(size: .medium)!).to(equal(URL(string: "http://musicmeta.phinf.naver.net/album/000/123/123456.jpg?type=r104Fll")))
      }
      
      it("large") {
        let album = Album()
        album.id = "123456"
        
        expect(album.coverImageURL(size: .large)!).to(equal(URL(string: "http://musicmeta.phinf.naver.net/album/000/123/123456.jpg?type=r204Fll")))
      }
    }
  }
}
