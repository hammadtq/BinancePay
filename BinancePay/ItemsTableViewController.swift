//
//  ItemsTableViewController.swift
//  
//
//  Created by Hammad Tariq on 18/05/2019.
//

import UIKit
import Alamofire
import SwiftyJSON

class ItemTableViewCell: UITableViewCell{
    
    
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
}

class ItemsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    
    @IBOutlet var tableView: UITableView!
    var itemsArray = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .none
        fetchItems(url: "http://api.iologics.co.uk/binancepay/getItems.php?address=tbnb1mmehrux6snnuq6cq2gq4396m9lycwzy700l60a")
        
    }
    
    func fetchItems(url: String){
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let resultJSON : JSON = JSON(response.result.value!)
                    
                    for result in resultJSON{
                        var indiResult = [String]()
                        print(result.1["item_name"])
                        indiResult.append(result.1["item_name"].string ?? "");
                        indiResult.append(result.1["item_description"].string ?? "");
                        indiResult.append(result.1["item_image"].string ?? "");
                        indiResult.append(result.1["price"].string ?? "");
                        self.itemsArray.append(indiResult);
                    }
                    print(self.itemsArray)
                    self.tableView.reloadData()
                }
        }
    }

    // MARK: - Table view data source

    

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCellItems", for: indexPath) as! ItemTableViewCell
        
        var items = itemsArray[indexPath.item]
        cell.itemTitle.text = items[0]
        cell.itemDescription.text = NSLocalizedString("\(items[1])", comment: "")
        cell.itemPrice.text = "$\(items[3])"
        cell.itemTitle.sizeToFit()
        cell.itemDescription.sizeToFit()
        cell.backgroundColor = UIColor(red:1.00, green:0.92, blue:0.65, alpha:1.0)
        Alamofire.request(items[2]).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                cell.itemImage.image = image
                //cell.thumbnailImage.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }
        return cell
    }
    

    

}
