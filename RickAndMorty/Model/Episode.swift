//  Episode.swift
//  RickAndMorty


import Foundation
class EmbededInEpizodes:Codable{
    var info:Info
    var results:[Episode]
}

class Episode:Codable{
    var id:Int
    var name:String
    var airDate:String
    var episodeNumber:String
    var characters:[String]
    var url:String
    var created:String
    init(id:Int,name:String,airDate:String,episodeNumber:String,characters:[String],url:String,created:String){
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.characters = characters
        self.url = url
        self.created = created
    }
    enum CodingKeys:String,CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episodeNumber = "episode"
        case characters = "characters"
        case url = "url"
        case created = "created"
    }
}
