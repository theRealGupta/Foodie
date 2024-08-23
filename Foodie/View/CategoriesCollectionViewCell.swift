//
//  CategoriesCollectionViewCell.swift
//  Foodie
//
//  Created by Mahmoud Alaa on 22/08/2024.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCategories: UIImageView!{
        didSet{
            imageCategories.layer.cornerRadius = imageCategories.frame.height / 2
            imageCategories.clipsToBounds = true
        }
    }
    
}