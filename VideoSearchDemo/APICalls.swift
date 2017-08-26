//
//  APICalls.swift
//  VideoSearchDemo
//
//  Created by Vikash Kumar on 26/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation



//APICAlls
//Constants
let giphyAPIKey = "958fa91a625942468d631ce9c5e49ef1"

class APICall {
    static let shared = APICall()
    
    let searchURL = "http://api.giphy.com/v1/gifs/search?api_key=\(giphyAPIKey)&limit=5&q="
        
    typealias ResponseBlock = (Any?, Bool)-> Void
    
    func search(keyword: String, block: @escaping ResponseBlock) {
        let urlString = searchURL + keyword
        let url = URL(string: urlString)!
       
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        
    }
    
    
}
