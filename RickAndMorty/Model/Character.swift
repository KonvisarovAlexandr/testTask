//
//  Character.swift
//  RickAndMorty


import Foundation


class EmbededModel:Codable {
    var info:Info
    var results:[Character]
    init(info:Info,results:[Character]){
        self.info =  info
        self.results = results
    }
    
    enum CodingKeys:String,CodingKey{
        case info = "info"
        case results = "results"
    }
}

class Info:Codable {
    var count:Int
    var pages:Int
    var next:String?
    var prev:String?
    init(count:Int,pages:Int,next:String?,prev:String?){
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }
    enum CodingKeys:String,CodingKey{
        case count = "count"
        case pages = "pages"
        case next = "next"
        case prev = "prev"
    }
}

class Character:Codable{
    var id :Int
    var name:String
    var status:String
    var species:String
    var type:String
    var gender:String
    var origin:Origin
    var location:Location
    var image:String
    var episode:[String]
    var url:String
    var created:String
    
    init(id :Int,name:String,status:String,species:String,type:String,gender:String,origin:Origin,location:Location,image:String,episode:[String],url:String,created:String){
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
    
    enum CodingKeys:String,CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case type = "type"
        case gender = "gender"
        case origin = "origin"
        case location = "location"
        case image = "image"
        case episode = "episode"
        case url = "url"
        case created = "created"
    }
}

class Origin:Codable{
    var name:String
    var url:String
    init(name:String,url:String){
        self.name = name
        self.url = url
    }
    enum CodingKeys:String,CodingKey {
        case name = "name"
        case url = "url"
    }
}


