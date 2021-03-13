//
//  GAPSIProductListVC.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class GAPSIProductListVC: UIViewController {

    var product: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getProducts()
    }
    
    // This method would let us get the list of Products that the user is searching for
    private func getProducts() {
        NetworkManager.shared.getProducts(for: product) { result in
            switch result {
            case .success(let products):
                print(products)
            case .failure(let error):
                self.presentGAPSIAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

}
