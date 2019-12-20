//
//  Service.swift
//  EngineerAITest
//
//  Created by Kushal Mandala on 20/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

class Service: NSObject {
    static var shared = Service()
    
    func requestPosts(url: String, completion: @escaping (PostInfo) -> Void) {
    
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard data != nil else {
                completion(PostInfo())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let postInfo = try jsonDecoder.decode(PostInfo.self, from: data!)
                completion(postInfo)
            } catch {
                print("Error \(error)")
            }
            
        }.resume()
    }

}
