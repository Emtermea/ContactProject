//
//  ContactManager.swift
//  ContactProject
//
//  Created by Emmanuelle TERMEAU on 12/10/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit
import CoreData

class ContactManager: NSObject {

    let query = "http://www.storage42.com/contacts.json"
    
    func getDataWith(completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        
        guard let url = URL(string: query) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            } catch let error {
                print(error)
            }
            }.resume()
    }
}

enum Result <T>{
    case Success(T)
    case Error(String)
}

