//
//  PaymentViewController.swift
//  BinancePay
//
//  Created by Hammad Tariq on 18/05/2019.
//  Copyright © 2019 Hammad Tariq. All rights reserved.
//

import UIKit
import Alamofire
import BinanceChain
import SwiftyJSON

class PaymentViewController: UIViewController {
    let testnet = "https://testnet-explorer.binance.org/tx/"
    @IBOutlet weak var titleOfItem: UILabel!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    var itemArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        //titleOfPurchase.text = "itemName"
        fillDetails()
        
        // Do any additional setup after loading the view.
    }
    
    func fillDetails(){
        print(itemArray)
        titleOfItem.text = itemArray[0]
        itemPrice.text = itemArray[3]
        itemDescription.text = itemArray[1]
        titleOfItem.sizeToFit()
        itemDescription.sizeToFit()
        
        Alamofire.request(itemArray[2]).response { response in
            if let data = response.data {
                let image = UIImage(data: data)
                self.itemImageView.image = image
                //cell.thumbnailImage.image = image
            } else {
                print("Data is nil. I don't know what to do :(")
            }
        }
    }
    
    
    @IBAction func payButtonPressed(_ sender: Any) {
        let binance = BinanceChain(endpoint: .testnet)
        let wallet = Wallet(mnemonic: "depth math nuclear wage board push system ugly movie retreat elephant valve coconut top super seek gasp rigid bitter network universe silly toast myth", endpoint: .testnet)
        wallet.synchronise() { (error) in
            
            print("wallet.init", wallet, error)
            // Create a new transfer
            let amount : Double = 0.01
            let msgTransfer = Message.transfer(symbol: "BNB", amount: amount, to: "tbnb1mmehrux6snnuq6cq2gq4396m9lycwzy700l60a", wallet: wallet)
            
            //let msg = Message.newOrder(symbol: "BNB_BTC.B-918", orderType: .limit, side: .buy, price: 100, quantity: 1, timeInForce: .goodTillExpire, wallet: wallet)
            
            // Broadcast the message
            binance.broadcast(message: msgTransfer, sync: true) { (response) in
                if let error = response.error { return print(error) }
                print("hello");
                let alertTitle = NSLocalizedString("Success", comment: "")
                let alertMessage = NSLocalizedString("Your Transaction has been complete!", comment: "")
                let okButtonText = NSLocalizedString("View Transaction", comment: "")
                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: okButtonText, style: .default, handler: { (action: UIAlertAction) in
                    print(response.broadcast[0].hash)
                    UIApplication.shared.openURL(NSURL(string: "\(self.testnet)\(response.broadcast[0].hash)")! as URL)
                }))
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func transactionSuccess(){
        print("pohanch hi gaye")
    }
    
}
