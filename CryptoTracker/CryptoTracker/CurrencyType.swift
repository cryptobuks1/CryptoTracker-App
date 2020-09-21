//
//  CurrencyType.swift
//  CryptoTracker
//
//  Created by Alex Mougios on 5/6/20.
//  Copyright © 2020 Alex Mougios. All rights reserved.
//
//Instructions and Code partially taken from Max Stein
//https://maxste.in/build-an-ethereum-bitcoin-price-tracking-app-in-swift-f467b7f3ae35
import UIKit

enum CurrencyType: String {
    case btc = "BTC",
    bch = "BCH",
    eos = "EOS",
    eth = "ETH",
    ltc = "LTC",
    xlm = "XLM",
    xrp = "XRP",
    xmr = "XMR",
    neo = "NEO"
    
    var apiURL: URL? {
        let apiString = "https://min-api.cryptocompare.com/data/price?fsym=" + rawValue + "&tsyms=AUD"
        return URL(string: apiString)
    }
    
    var name: String {
        switch self {
        case .btc:
            return "Bitcoin"
        case .bch:
            return "Bitcoin Cash"
        case .eos:
            return "EOS"
        case .eth:
            return "Ethereum"
        case .ltc:
            return "Litecoin"
        case .xlm:
            return "Stellar"
        case .xrp:
            return "Ripple"
        case .xmr:
            return "Monero"
        case .neo:
            return "NEO"
        }
    }
    
    var image: UIImage {
        switch self {
        case .btc:
            return #imageLiteral(resourceName: "Bitcoin")
        case .bch:
            return #imageLiteral(resourceName: "BCH")
        case .eos:
            return #imageLiteral(resourceName: "EOS")
        case .eth:
            return #imageLiteral(resourceName: "Ethereum")
        case .ltc:
            return #imageLiteral(resourceName: "Litecoin")
        case .xlm:
            return #imageLiteral(resourceName: "XLM")
        case .xrp:
            return #imageLiteral(resourceName: "Ripple")
        case .xmr:
            return #imageLiteral(resourceName: "Monero")
        case .neo:
            return #imageLiteral(resourceName: "NEO")
        }
    }
    
    func requestValue(completion: @escaping (_ value: NSNumber?) -> Void) {
            guard let apiURL = apiURL else {
                completion(nil)
                print("URL Invalid")
                return
            }
            let request = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(nil)
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                        let value = json["AUD"] as? NSNumber else {
                            completion(nil)
                            return
                    }
                    completion(value)
                } catch  {
                    completion(nil)
                    print(error.localizedDescription)
                }
            }
            request.resume()
        }
    }
