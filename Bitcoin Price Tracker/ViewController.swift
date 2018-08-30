//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Vu Duong on 8/30/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var secondPriceLbl: UILabel!
    @IBOutlet weak var thirdPriceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User Defaults practice
//        UserDefaults.standard.set(123.56, forKey: "USD")
//        UserDefaults.standard.synchronize()
//        let price = UserDefaults.standard.double(forKey: "USD")
//        print(price)
        getDefaultPrices()
        getPrice()
    }
    
    func getDefaultPrices() {
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            self.priceLbl.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
            UserDefaults.standard.set(usdPrice, forKey: "USD")
        }
        
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY") 
        if jpyPrice != 0.0 {
            self.secondPriceLbl.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
            UserDefaults.standard.set(jpyPrice, forKey: "JPY")
        }
        
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0 {
            self.thirdPriceLbl.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
            UserDefaults.standard.set(eurPrice, forKey: "EUR")
        }
        
        UserDefaults.standard.synchronize()

    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Double] {
                        if let jsonDictionary = json {
                            DispatchQueue.main.async {
                                if let usdPrice = jsonDictionary["USD"] {
                                    self.priceLbl.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
                                }
                                if let jpyPrice = jsonDictionary["JPY"] {
                                    self.secondPriceLbl.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
                                }
                                if let eurPrice = jsonDictionary["EUR"] {
                                    self.thirdPriceLbl.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
                                }
                            }
                        }
                    }
                    print("It worked!")
                } else {
                    print("Somthing went wrong!")
                }
                }.resume()
        }
    }
    
    func doubleToMoneyString(price: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        let priceString = formatter.string(from: NSNumber(value: price))
        if priceString == nil {
            return "ERROR"
        } else {
            return priceString!
        }
        
    }
    
    @IBAction func refreshedBtnPressed(_ sender: Any) {
        getPrice()
        
    }
}

