//
//  ContactCollectionViewCell.swift
//  ContactProject
//
//  Created by Emmanuelle TERMEAU on 12/11/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    func setContactCellWith(contact: Contact) {
        DispatchQueue.main.async {
            if let url = contact.picture {
                self.imageViewCell.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
//                self.photoImageview.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
    
}
