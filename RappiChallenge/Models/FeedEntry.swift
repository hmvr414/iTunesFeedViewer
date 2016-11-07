//
//  FeedEntry.swift
//  RappiChallenge
//
//  Created by Hermann Vallejo on 2/11/16.
//  Copyright © 2016 Hermann Vallejo. All rights reserved.
//
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class FeedImage : Object, Mappable
{
    dynamic var size = ""
    dynamic var url = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        url <- map["label"]
        size <- map["attributes.height"]
    }
}

class FeedCategory : Object, Mappable
{
    dynamic var term = ""
    dynamic var label = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        term <- map["attributes.term"]
        label <- map["attributes.label"]
    }
}

class FeedEntry : Object, Mappable
{
    dynamic var id = ""
    dynamic var name = ""
    dynamic var summary = ""
    dynamic var contentType = ""
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var releaseDate = ""
    dynamic var link = ""
    var images = List<FeedImage>()
    var category: FeedCategory?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["id.attributes.im:id"]
        name <- map["im:name.label"]
        summary <- map["summary.label"]
        contentType <- map["im:contentType.attributes.label"]
        title <- map["title.label"]
        artist <- map["im:artist.label"]
        releaseDate <- map["im:releaseDate.label"]
        link <- map["link.attributes.href"]
        images <- (map["im:image"], ListTransform<FeedImage>())
        category <- map["category"]
    }
}

class ITunesFeed : Object, Mappable
{
    dynamic var name = ""
    var apps : List<FeedEntry>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["feed.title.label"]
        apps <- (map["feed.entry"], ListTransform<FeedEntry>())
    }
}
