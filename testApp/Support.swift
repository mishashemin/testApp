//
//  File.swift
//  testApp
//
//  Created by  misha shemin on 24/01/2020.
//  Copyright © 2020 mishashemin. All rights reserved.
//
import UIKit

protocol ViewModelProtocol {
    func errorHandler()
    func receive(data : Res)
}

protocol RequstModelProtocol {
    var count:Int {get set}
    func search(str:String, id: ID, receiver: ViewModelProtocol) -> Bool
    
}

struct Res: Codable{
    let response: Response?
}

struct Response:Codable {
    let count:Int?
    let items:[Items]?
    
}
struct Items: Codable{
    let id:Int?
    let name:String?
    let firstName:String?
    let lastName:String?
    let screenName:String?
    let photo:String?
    let photo100:String?
    let photo200:String?
    
    enum CodingKeys:String,CodingKey {
        case id
        case name
        case firstName = "first_name"
        case lastName = "last_name"
        case screenName = "screen_name"
        case photo
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}


enum ID {
    case user
    case group
}


class RequestHandler {
    let modAlone: String = "/users.search"
    let modGroup: String = "/groups.search"
    let apiVK:String = "https://api.vk.com/method"
    let token:String = "99d54d469f2eebd8372f492d286ec01916da715d44f0e712637b0108e8e6011c62ddfa7310ad42ec9f019"
    
    var count: Int = 0
    
    private func searchUser(_ str:String, _ receiver: ViewModelProtocol)->Bool{
        
        let encodedText = str.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var urlString = ""
        if let encodedText = encodedText{
            urlString = apiVK + modAlone + "?q=\(encodedText)&fields=photo,photo_100,photo_200,screen_name&count=\(count)&access_token=\(token)&v=5.103"
        }
        else { return false }
        guard let url = URL(string: urlString) else { return false }
        requestSubnission(url,receiver)
        return true
    }
    
    private func searchGroup(_ str:String, _ receiver: ViewModelProtocol)->Bool{
        
        if str == "" { return false }
        let encodedText = str.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var urlString = ""
        if let encodedText = encodedText{
            urlString = apiVK + modGroup + "?q=\(encodedText)&count=\(count)&access_token=\(token)&v=5.103"
        }
        else{ return false }
        guard let url = URL(string: urlString) else { return false }
        requestSubnission(url,receiver)
        return true
    }
    
    private func requestSubnission(_ url:URL,_ receiver: ViewModelProtocol)->Void{
        
        let session = URLSession.shared
        session.dataTask(with: url){ (data,resp,error) in
            if error == nil{
                if data != nil {
                    do{
                        let decoder = JSONDecoder()
                        let res = try decoder.decode(Res.self, from: data!)
                        DispatchQueue.main.async {
                            receiver.receive(data: res)
                        }
                        return
                    }
                    catch let errorJson {
                        print(errorJson)
                        DispatchQueue.main.async {
                            receiver.errorHandler()
                            return
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                receiver.errorHandler()
                return
            }
            }.resume()
    }
}

extension RequestHandler: RequstModelProtocol{
    
    func search(str : String,id: ID, receiver: ViewModelProtocol) -> Bool{
        switch id {
        case .user:
            return searchUser(str, receiver)
        case .group:
            return searchGroup(str, receiver)
        }
    }
}
    
extension UIImageView{
    
    func downloadedFrom(link:String) {
        guard let url = URL(string: link) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: {(data,_,error)-> Void in
            guard let data = data,error == nil,let image = UIImage(data: data) else {return}
            DispatchQueue.main.async { () -> Void in
                self.image = image
            }
            
        }).resume()
    }
}
