//
//  AllContactCollectionViewController.swift
//  ContactProject
//
//  Created by Emmanuelle TERMEAU on 12/11/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "contactCell"

class AllContactCollectionViewController: UICollectionViewController {
    

    @IBOutlet var allContactsCollection: UICollectionView!
    
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Contact.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "email", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//         frc.delegate = self
        return frc
    }()
    
    
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
    
    func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func updateCollectionContent() {
        do {
            try self.fetchedhResultController.performFetch()
            print("count of section FRC",self.fetchedhResultController.sections?.count as Any)
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
        ViewController.contactManager.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let msg):
                print(msg)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionContent()

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
        if let count = fetchedhResultController.sections?.count {
            return count
        }
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContactCollectionViewCell
        if (fetchedhResultController.sections?.count)! < (indexPath.count) {
            if let contact = fetchedhResultController.object(at: indexPath) as? Contact {
                cell.setContactCellWith(contact: contact)
                cell.backgroundColor = UIColor.black
                return cell
            }
        }
        return cell
    }

}

