//
//  Location.swift
//  RickAndMorty


import Foundation
class Location:Codable{
    var id:Int?
    var name:String
    var type:String?
    var dimension:String?
    var residents:[String]?
    var url:String
    var created:String?
    init(name:String,url:String){
        self.name = name
        self.url = url
    }
    enum CodingKeys:String,CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case dimension = "dimension"
        case residents = "residents"
        case url = "url"
        case created = "created"
    }
}
