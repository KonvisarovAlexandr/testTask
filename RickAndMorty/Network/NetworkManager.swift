//
//  NetworkManager.swift
//  RickAndMorty
//

import Foundation

public class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://rickandmortyapi.com/api/"
    let decoder:JSONDecoder = JSONDecoder()
    let task: URLSessionDataTask? = nil
    let session = URLSession.shared
    
    func getOneEpizode(url:String,completion: @escaping ((Episode?)->Void)){
        let url = URL(string:url)!
        
        let task:URLSessionDataTask = session.dataTask(with: url, completionHandler: {
            data, responce, error in
            print((responce as? HTTPURLResponse)?.statusCode)
            
            if error != nil{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let parsedData = try self.decoder.decode(Episode.self, from: data)
                    completion(parsedData)
                } catch {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    func getCharacters(url:String,page:Int = 0,completion: @escaping (([Character]?)->Void)){
        let url = URL(string:url + "?page=\(page)")!
        
        let task:URLSessionDataTask = session.dataTask(with: url, completionHandler: {
            data, responce, error in
            print((responce as? HTTPURLResponse)?.statusCode)
            
            if error != nil{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let parsedData = try self.decoder.decode(EmbededModel.self, from: data)
                    completion(parsedData.results)
                } catch {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    func getSingleCharacter(charterUrl:String,completion: @escaping ((Character?)->Void)){
        let url = URL(string:charterUrl)!
        let task:URLSessionDataTask = session.dataTask(with: url, completionHandler: {
            data, responce, error in
            if error != nil{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let parsedData = try self.decoder.decode(Character.self, from: data)
                    completion(parsedData)
                } catch {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    func getCharactersByEpisode(selfId:String,episodeUrl:String,completion:@escaping (([Character]?)->Void)){
        if episodeUrl == "" {
            completion(nil)
            return
        }
        let url = URL(string:episodeUrl)!
        let task:URLSessionDataTask = session.dataTask(with: url, completionHandler: {
            data, responce, error in
            if error != nil{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let parsedData = try self.decoder.decode( Location.self, from: data)
                    var arrayOfIds:String = "https://rickandmortyapi.com/api/character/"
                    parsedData.residents?.forEach({ link in
                        let number = link.replacingOccurrences(of: "https://rickandmortyapi.com/api/character/", with: "")
                        if number != selfId {
                            arrayOfIds.append(number)
                            arrayOfIds.append(",")
                            
                        }
                    })
                    NetworkManager.shared.getCharactersWithoutPage(url: arrayOfIds, completion: { responce in
                        print(responce)
                        completion(responce)
                    })
                } catch {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
    func getCharactersWithoutPage(url:String,completion: @escaping (([Character]?)->Void)){
        let url = URL(string:url )!
        
        let task:URLSessionDataTask = session.dataTask(with: url, completionHandler: {
            data, responce, error in
            print((responce as? HTTPURLResponse)?.statusCode)
            
            if error != nil{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil)
                    return
                }
                do {
                    let parsedData = try self.decoder.decode([Character].self, from: data)
                    completion(parsedData)
                } catch {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
    
}
