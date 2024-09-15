//
//  ProductViewController.swift
//  Foodie
//
//  Created by Mahmoud Alaa on 15/09/2024.
//

import UIKit

class ProductViewController: UIViewController {
    
    
    var nameOfFoodImage = "Pepperoni pizza"
    var priceOfFood = "L.E65,000"
    var descriptionOfFoodImage = """
        Highlights
        Button detailed trench coat has v-neck cutting
        Pocket detailed, two front patch pockets at the bottom
        Made with polyester blended material
        """
  
    @IBOutlet weak var headerView: HeaderOfProductToCartView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        
        // Header view
        headerView.imageView.image = UIImage(named: nameOfFoodImage)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize navBar
        navigationController?.navigationBar.tintColor = UIColor(red: 82, green: 2, blue: 56)
    }

    @IBAction func plusBtn(_ sender: UIButton) {
       if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NameAndPriceOfRestaurantTableViewCell{
           cell.orderCount += 1
        }
    }
    @IBAction func minuseBtn(_ sender: UIButton) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NameAndPriceOfRestaurantTableViewCell{
            if cell.orderCount > 0 {
                cell.orderCount -= 1
            }
        }
    }
    // Add to cart
    @IBAction func addToCart(_ sender: UIButton) {
        
    }
}

// MARK: - UITable View Delegate

extension ProductViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameOfEat", for: indexPath) as? NameAndPriceOfRestaurantTableViewCell else{
                return UITableViewCell()
            }
            cell.foodName.text = nameOfFoodImage
            cell.foodePrice.text = priceOfFood
            return cell   
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "size", for: indexPath) as? sizeOfFoodTableViewCell else{
                return UITableViewCell()
            }
            return cell        
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Highlights", for: indexPath) as? HighlightsTableViewCell else{
                return UITableViewCell()
            }
            
            cell.descriptionOfFood.text = descriptionOfFoodImage
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addToCart", for: indexPath) as? AddToCartTableViewCell else{
                return UITableViewCell()
            }
            
            return cell
            
        default:
            fatalError("Error in cell of table view of productViewController")
        }
    }
    
    // Height table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return UIScreen.main.bounds.width * 0.138  // name and price
        case 1:
            return  UIScreen.main.bounds.width * 0.208 // size
        case 2:
            return 120  // Highlights
        case 3:
            return UIScreen.main.bounds.width * 0.167 // Button
       
        default:
            fatalError("Error in height of Product view controller")
        }
    }
}
