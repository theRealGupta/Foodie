//
//  HomeViewController.swift
//  Foodie
//
//  Created by Mahmoud Alaa on 20/08/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    var imagesOfSliderCollection = [
        UIImage(named: "slider1"),
        UIImage(named: "slider2"),
        UIImage(named: "slider3"),
        UIImage(named: "slider4")
    ]
    
    @IBOutlet weak var searchIcon: UIButton!
        
    
    @IBOutlet weak var pictureOfPerson: UIImageView!{
        didSet{
            pictureOfPerson.layer.cornerRadius = pictureOfPerson.frame.height / 2
            pictureOfPerson.clipsToBounds = true
            
            if let photoUrl = DataPersistentManager.shared.userImageURL {
                loadImage(from: photoUrl) { image in
                    self.pictureOfPerson.image = image
                }
            }
        }
    }
    @IBOutlet weak var nameOfPerson: UILabel!{
        didSet{
            if let userName = DataPersistentManager.shared.userName{ nameOfPerson.text = userName }
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.layer.cornerRadius = 15
            searchTextField.layer.masksToBounds = true
            searchTextField.placeholder = "Search About.."
        }
    }
    

    @IBOutlet weak var filterView: UIView!{
        didSet{
            filterView.layer.cornerRadius = 14
            filterView.layer.masksToBounds = true
            filterView.clipsToBounds = true
        }
    }
    
    var categoriesItems =
        Categories(title: "Categories", 
                   iamges: [
            UIImage(named: "Macdonalds"),
            UIImage(named: "KFC"),
            UIImage(named: "Common"),
            UIImage(named: "Pizza Hot"),
            UIImage(named: "Abou El Sid"),
            UIImage(named: "O's Pasta"),
            UIImage(named: "naguib mahfouz café"),
            UIImage(named: "Sequoia"),
            UIImage(named: "Zitouni"),
            UIImage(named: "Saigon"),
            UIImage(named: "Zooba"),
            UIImage(named: "Kadoura"),
        ],
        names: [ "Macdonalds", "KFC", "Common", "Pizza Hot" ,"Abou El Sid" ,"O's Pasta" ,"naguib mahfouz café","Sequoia", "Zitouni", "Saigon", "Zooba","Kadoura"
                            ])
    
    var recommendedAndBest: [String: Product] = [
    "Recomoneded" : Product(title: "Recomoneded",
                names: ["Creamy Shrimp Pasta Salad" ,"Shrimp Noodle Salad" ,"Abdoogh Khiar" ,"Albaloo Polo","Chicken Sliders","Cranberry Oatmeal Cookies","French Onion Soup","Happy Meal® Double Cheeseburger","Instant Pot Poached Chicken","Italian Sausage Pasta","Kantooker Twist","Lemon Chicken And Rice Soup","Lemon Ricotta Pasta","Mediterranean Green Lentil Soup","Mighty Meal","Molten Lava Cake","Mushroom Barley Soup","Persian Style Shrimp and Rice","Ricotta Gnocchi"],
                prices: ["L.E 150" ,"L.E 270" ,"L.E 280" ,"L.E 300" ,"L.E 450" ,"L.E 190" ,"L.E 170","L.E 180" ,"L.E 180" ,"L.E 350" ,"L.E 320" ,"L.E 220" ,"L.E 350" ,"L.E 160","L.E 200" ,"L.E 340" ,"L.E 230" ,"L.E 220" ,"L.E 230" ],
                images: [UIImage(named:"Creamy Shrimp Pasta Salad")! ,UIImage(named:"Shrimp Noodle Salad")! ,UIImage(named:"Abdoogh Khiar")! ,UIImage(named:"Albaloo Polo")!,UIImage(named:"Chicken Sliders")!,UIImage(named:"Cranberry Oatmeal Cookies")!,UIImage(named:"French Onion Soup")!,UIImage(named:"Happy Meal® Double Cheeseburger")!,UIImage(named:"Instant Pot Poached Chicken")!,UIImage(named:"Italian Sausage Pasta")!,UIImage(named:"Kantooker Twist")!,UIImage(named:"Lemon Chicken And Rice Soup")!,UIImage(named:"Lemon Ricotta Pasta")!,UIImage(named:"Mediterranean Green Lentil Soup")!,UIImage(named:"Mighty Meal")!,UIImage(named:"Molten Lava Cake")!,UIImage(named:"Mushroom Barley Soup")!,UIImage(named:"Persian Style Shrimp and Rice")!,UIImage(named:"Ricotta Gnocchi")!]),
    "BestSeller" :   Product(title: "BestSeller",
                              names: ["Chocolate Walnut Skillet Brownie" ,"Bamya" ,"Banana Peanut Butter Coco Puff Milkshake" ,"Classic Eggplant Lasagna","Creamy Oatmeal Recipe Middle","Easy Greek Chicken","Easy Spicy Shrimp Marinara","Eggplant Caponata","Italian Bruschetta","Italian Skillet Chicken","Middle Eastern Chicken And Rice","Olive Oil Bread Dip","Persian Dolmeh","Salmon Burgers","Sour Cherry Galette","Waffle"],
                              prices: ["L.E 250" ,"L.E 190" ,"L.E 210" ,"L.E 300" ,"L.E 420" ,"L.E 350" ,"L.E 310","L.E 250" ,"L.E 330" ,"L.E 250" ,"L.E 230" ,"L.E 200" ,"L.E 150" ,"L.E 170","L.E 230","L.E 260"],
                              images: [UIImage(named:"Chocolate Walnut Skillet Brownie")! ,UIImage(named:"Bamya")! ,UIImage(named:"Banana Peanut Butter Coco Puff Milkshake")! ,UIImage(named:"Classic Eggplant Lasagna")!,UIImage(named:"Creamy Oatmeal Recipe Middle")!,UIImage(named:"Easy Greek Chicken")!,UIImage(named:"Easy Spicy Shrimp Marinara")!,UIImage(named:"Eggplant Caponata")!,UIImage(named:"Italian Bruschetta")!,UIImage(named:"Italian Skillet Chicken")!,UIImage(named:"Middle Eastern Chicken And Rice")!,UIImage(named:"Olive Oil Bread Dip")!,UIImage(named:"Persian Dolmeh")!,UIImage(named:"Salmon Burgers")!,UIImage(named:"Sour Cherry Galette")!,UIImage(named:"Waffle")!]
                             )
               ]
    
    var allProducts: [FilterProduct] = []
    var filteredProducts: [FilterProduct] = []
    var checkFiltered = false
    
    // New Offer
    var newOffer = [NewOffer(descripion: "Enjoy your favorite food at discounted prices of up to 50%", image: UIImage(named: "NewOffer1"))]
    
    // Popular Food
    var pupularFood = Product(
        title: "Popular Food",
        names: ["Grilled chicken" ,"Vegetables pizza", "Meat pizzza", "Rice cake"],
    prices: ["150 L.E","260L.E" ,"95 L.E" ,"300 L.E"],
        images: [UIImage(named: "Grilled chicken")!, UIImage(named: "Vegetables pizza")!, UIImage(named: "Meat pizzza")!, UIImage(named: "Rice cake")!] )
    
    var favoriteBoolForRecommended = [Bool]()
    var favoriteBoolForBestSeller = [Bool]()
    var userId = ""
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Search text field
        searchTextField.delegate = self
        loadAllProduct()
        
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        
        // Register the product nib file
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "productCell")
        
        //Register the newOfferProduct nib file
        let nib2 = UINib(nibName: "NewOfferTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "newOfferCell")
        
        // Register the Popular Food nib file
        let nib3 = UINib(nibName: "PopularFoodTableViewCell", bundle: nil)
        tableView.register(nib3, forCellReuseIdentifier: "PopularFoodCell")
        
        //Register the filterProducts nib file
        let nib4 = UINib(nibName: "FilterTableViewCell", bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: "filterCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // User info
        userId = DataPersistentManager.shared.userId
        
        
        // Initialize favorite booleans
        initializeFavoriteBooleans(for: userId)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Load an image from a URL
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void){
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) ,let image = UIImage(data: data){
                DispatchQueue.main.async {
                    completion(image)
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
 
    // Initialize favorite booleans
    func initializeFavoriteBooleans(for userId: String) {
        let defaults = UserDefaults.standard
        let hasLaunchedKey = "hasLaunchedBefore_\(userId)" // User-specific key

        if !defaults.bool(forKey: hasLaunchedKey) {
               favoriteBoolForRecommended = Array(repeating: false, count: recommendedAndBest["Recomoneded"]?.names.count ?? 0)
               favoriteBoolForBestSeller = Array(repeating: false, count: recommendedAndBest["BestSeller"]?.names.count ?? 0)
               
               saveFavoriteStatusToUserDefaults(for: userId)
               
               defaults.set(true, forKey: hasLaunchedKey)
               defaults.synchronize() // To ensure data is saved immediately
               
               print("App launched for the first time for user \(userId), initialized favorites")
           } else {
               print("App has launched before for user \(userId), fetching saved favorites")
               fetchFavoriteStatusFromUserDefaults(for: userId)
           }
    }
    
    // Save favorite status to user defaults
    func saveFavoriteStatusToUserDefaults(for userId: String) {
        let defaults = UserDefaults.standard
        
        // Save recommended favorites
        if let recommendedData = try? NSKeyedArchiver.archivedData(withRootObject: favoriteBoolForRecommended, requiringSecureCoding: false) {
            defaults.set(recommendedData, forKey: "favoriteBoolForRecommended_\(userId)") // User-specific key
        }
        
        // Save best seller favorites
        if let bestSellerData = try? NSKeyedArchiver.archivedData(withRootObject: favoriteBoolForBestSeller, requiringSecureCoding: false) {
            defaults.set(bestSellerData, forKey: "favoriteBoolForBestSeller_\(userId)") // User-specific key
        }
        
        defaults.synchronize() // Ensure data is saved immediately
        print("Favorite status saved to UserDefaults for user \(userId)!")
    }
    
    // fetch favorite status
    func fetchFavoriteStatusFromUserDefaults(for userId: String) {
        let defaults = UserDefaults.standard
        if let recommendedData = defaults.data(forKey: "favoriteBoolForRecommended_\(userId)"), // User-specific key
           let bestSellerData = defaults.data(forKey: "favoriteBoolForBestSeller_\(userId)"),   // User-specific key
           let recommendedBool = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: recommendedData) as? [Bool]),
           let bestSellerBool = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: bestSellerData) as? [Bool]) {
            favoriteBoolForRecommended = recommendedBool
            favoriteBoolForBestSeller = bestSellerBool
            print("Successfully fetched favorites from UserDefaults for user \(userId)!")
        } else {
            print("Error fetching favorites for user \(userId)")
        }
        
    }
}

// MARK: - Table View Delegate

extension HomeViewController: UITableViewDelegate ,UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkFiltered{
            return filteredProducts.count
        }else{
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        
        if checkFiltered{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as? FilterTableViewCell else{
                return UITableViewCell()
            }
            cell.nameLabel.text = filteredProducts[indexPath.row].names
            cell.priceLabel.text = filteredProducts[indexPath.row].prices
            cell.imgView.image = filteredProducts[indexPath.row].images
            
            return cell
        }else{
            
            switch indexPath.row{
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderImagesCell", for: indexPath) as? SliderImagesTableViewCell else{
                    return UITableViewCell()
                }
                cell.delegateSliderImage = self
                
                cell.setUpImages(images: imagesOfSliderCollection)
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as? CategoriesTableViewCell else{
                    return UITableViewCell()
                }
                
                cell.categoriesDelegate = self
                
                cell.setUpCell(title: categoriesItems.title, photos: categoriesItems.iamges)
                cell.names = categoriesItems.names
                cell.selectionStyle = .none
                return cell
            case 2...3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else{
                    print("Error in product table view cell")
                    return UITableViewCell()
                }
                
                cell.favoriteDelegate = self
                cell.selectedDelegate = self
                
                if (indexPath.row == 2){ // Recommended
                    cell.titleLabel.text = recommendedAndBest["Recomoneded"]?.title
                    cell.photos = recommendedAndBest["Recomoneded"]!.images
                    cell.name = recommendedAndBest["Recomoneded"]!.names
                    cell.price = recommendedAndBest["Recomoneded"]!.prices
                    cell.isFavorited = favoriteBoolForRecommended
                    
                }else{ // Best seller
                    cell.titleLabel.text = recommendedAndBest["BestSeller"]?.title
                    cell.photos = recommendedAndBest["BestSeller"]!.images
                    cell.name = recommendedAndBest["BestSeller"]!.names
                    cell.price = recommendedAndBest["BestSeller"]!.prices
                    cell.isFavorited = favoriteBoolForBestSeller
                }
                cell.tableViewRow = indexPath.row
                cell.selectionStyle = .none
                cell.userId = userId
                return cell
            case 4:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "newOfferCell", for: indexPath) as? NewOfferTableViewCell else{
                    print("Error in Offer table view cell")
                    return UITableViewCell()
                }
                
                cell.titleOfCell.text = "New Offer"
                cell.descriptionLabel.text = newOffer[0].descripion
                cell.backgroundImage.image = UIImage(named: "Discount 50%")
                cell.selectionStyle = .none
                return cell
            case 5:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularFoodCell", for: indexPath) as? PopularFoodTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.delegateOfPopularItem = self
                cell.titleLabel.text = "Popular Food"
                cell.name = pupularFood.names
                cell.price = pupularFood.prices
                cell.photos = pupularFood.images
                cell.selectionStyle = .none
                
                return cell
            default:
                fatalError("Error in when specific number of row in HomeViewContoller")
            }
        }
    }
    
   // Hight table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if checkFiltered {
            return 150
        }else{
            
            switch indexPath.row {
            case 0:
                if UIScreen.main.bounds.height < 900{
                    return UIScreen.main.bounds.height * 0.14
                }else{
                    return UIScreen.main.bounds.height * 0.24
                }
            case 1:
                return 130
            case 2...3:
                return 200
            case 4:
                return 160
            case 5:
                return 300
                
            default:
                fatalError("Error in height for row at in home view controller")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // New offer
        if indexPath.row == 4{
            guard let destinationVC = UIStoryboard(name: "SpecificRestaurant", bundle: nil).instantiateViewController(withIdentifier: "FoodsOfSpecificRestaurantViewController") as? FoodsOfSpecificRestaurantViewController else { return }
            destinationVC.selectedItem = "Discount 50%"
            self.show(destinationVC, sender: self)
        }
        // Selected filter item in table view
        else if checkFiltered{
            
            let storyBoard = UIStoryboard(name: "Product", bundle: nil)
            guard let destinationVC = storyBoard.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else { return }
            
            destinationVC.nameOfFoodImage = filteredProducts[indexPath.row].names
            destinationVC.priceOfFood = filteredProducts[indexPath.row].prices
            self.show(destinationVC, sender: self)
        }
        
    }
  
}
// MARK: - Did selected Items

extension HomeViewController: CategoriesTableViewCellDelegate, ProductTableViewCellDelegate ,PopularFoodTableViewCellDelegate, SliderImagesTableViewCellDelegate ,isFavoriteChangedDelegate{
    
    func favoriteChanged(isFavorite: [Bool], row: Int, value: Bool) {
        if row == 2{
            favoriteBoolForRecommended = isFavorite
        }else if row == 3{
            favoriteBoolForBestSeller = isFavorite
        }
        
        if value{
            let alert = AlertViewController()
            alert.messageOfLabel = "Added To Favorites"
            alert.imageName = "Favorite"
            alert.appear(sender: self)
        }
    }
    
    func didSelectedItem(at indexPath: IndexPath){
        
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: "FoodsOfSpecificRestaurantViewController") as? FoodsOfSpecificRestaurantViewController else{ return }
        
        destinationVC.selectedItem = categoriesItems.names[indexPath.row]
        self.show(destinationVC, sender: self)
    }
    
    func didselectedItem(at indexPath: IndexPath, for tableViewRow: Int) {
        
        guard let destinationVC = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else{
            return
        }

        switch tableViewRow{
            
        case 2:
            destinationVC.nameOfFoodImage = recommendedAndBest["Recomoneded"]!.names[indexPath.row]
            destinationVC.priceOfFood = recommendedAndBest["Recomoneded"]!.prices[indexPath.row]
            
            destinationVC.isFavorite = favoriteBoolForRecommended[indexPath.row]
           
        case 3:
            destinationVC.nameOfFoodImage = recommendedAndBest["BestSeller"]!.names[indexPath.row]
            destinationVC.priceOfFood = recommendedAndBest["BestSeller"]!.prices[indexPath.row]
            
            destinationVC.isFavorite = favoriteBoolForBestSeller[indexPath.row]
            
        default:
            fatalError("Error when select item from Recommended or BesSeller Collection View")
        }
        
        self.show(destinationVC, sender: self)
    }
    
    // Selected Popular Item
    func didSelectedPopularItem(indexPath: IndexPath) {
        
        guard let destinationVC = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else{
            return
        }
        
        destinationVC.nameOfFoodImage = pupularFood.names[indexPath.row]
        destinationVC.priceOfFood = pupularFood.prices[indexPath.row]
        
        self.show(destinationVC, sender: self)
    }
    
    // Selected item in slider images
    func didSelectedSliderImage(indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(identifier: "FoodsOfSpecificRestaurantViewController") as? FoodsOfSpecificRestaurantViewController else { return }
        
        destinationVC.selectedItem = "Discount 10%"
        self.show(destinationVC, sender: self)
    }
}

// MARK: - UI Text Field Delgate

extension HomeViewController: UITextFieldDelegate{
    
    // Load allProducts
    func loadAllProduct(){
        
        for (_ ,product) in recommendedAndBest{
            
            for index in 0..<product.names.count {
                let filterProduct = FilterProduct(
                    names: product.names[index],
                    prices: product.prices[index],
                    images: product.images[index])
                
                allProducts.append(filterProduct)
            }
        }
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type anything"
            return false
        }else{
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else{ return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > 0{
            filterProducts(for: updatedText)
            checkFiltered = true
        }else{
            filteredProducts = allProducts
            checkFiltered = false
        }
        
        self.tableView.reloadData()
        return true
    }
    
    // Filter products
    func filterProducts(for query: String){
        
        filteredProducts = allProducts.filter { product in
            return product.names.localizedStandardContains(query) ||
                   product.prices.localizedStandardContains(query)
        }
    }
    
}

// Uploud new product
//        let group = DispatchGroup()
//        var imageUrls = [String]()
//
//        for (restaurantName, product) in recommendedAndBest {
//            for (index, image) in product.images.enumerated() {
//                group.enter()
//                let imageName = "\(restaurantName)_\(product.names[index])"
//
//                // Upload image and get the download URL
//                DataPersistentManager.shared.uploadImage(image: image, imageName: imageName) { url in
//                    if let imageUrl = url {
//                        imageUrls.append(imageUrl)  // Store the image URL
//                    }
//                    group.leave()
//                }
//            }
//        }
//        group.notify(queue: .main) { [self] in
//            // Once all uploads are done, save the image URLs and restaurant data in Firestore
//            DataPersistentManager.shared.saveToFirestore(restaurantData: recommendedAndBest, imageUrls: imageUrls, to: "recommendedAndBestSeller")
//        }
