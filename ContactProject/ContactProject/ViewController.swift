//
//  ViewController.swift
//  ContactProject
//
//  Created by Emmanuelle TERMEAU on 12/10/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var contactManager = ContactManager()
    
    func createContactEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let contactEntity = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as? Contact {
            contactEntity.username = dictionary["username"] as? String
            contactEntity.password = dictionary["password"] as? String
            contactEntity.gender = dictionary["gender"] as? String
            contactEntity.email = dictionary["email"] as? String
            contactEntity.cell = dictionary["cell"] as? String
            contactEntity.phone = dictionary["phone"] as? String
            let nameDic = dictionary["name"] as? [String: AnyObject]
            contactEntity.name = nameDic?["first"] as? String
            let picDic = dictionary["picture"] as? [String: AnyObject]
            contactEntity.picture = picDic?["medium"] as? String
            
            return contactEntity
        }
        return nil
    }
    
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createContactEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//            try fetchedhResultController.performFetch()
//            print("COUNT FETCHED FIRST: \(String(describing: fetchedhResultController.sections?[0].numberOfObjects))")
//        } catch let error  {
//            print("ERROR: \(error)")
//        }
        self.contactManager.getDataWith { (result) in
            switch result {
            case .Success(let data):
                print(data)
            case .Error(let msg):
                print(msg)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

