//
//  ProductTableViewCell.swift
//  Foodie
//
//  Created by Mahmoud Alaa on 11/09/2024.
//

import UIKit

protocol ProductTableViewCellDelegate{
    func didselectedItem (at indexPath: IndexPath ,for tableViewRow: Int)
}

class ProductTableViewCell: UITableViewCell {

    var tableViewRow: Int?
    
    var selectedDelegate: ProductTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [UIImage] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var name = [String]()
    var price = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "productCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "productCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

// MARK: - UICollection View Delegate

extension ProductTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as? productCollectionViewCell else{
            print("Error in productCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.productImage.image = photos[indexPath.row]
        cell.nameLabel.text = name[indexPath.row]
        cell.priceLabel.text = price[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150 , height: collectionView.frame.size.height)
    }
    //(UIScreen.main.bounds.width) * 0.43
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    // Did selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDelegate?.didselectedItem(at: indexPath ,for: tableViewRow ?? 0)
        
    }
}
