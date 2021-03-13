//
//  GAPSISearchHistoryListVC.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class GAPSISearchHistoryListVC: UIViewController {

    let tableView                     = UITableView()
    var products: [ProductSearched]   = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductSearchHistory()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Search History"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseID)
    }
    
    
    func getProductSearchHistory() {
        PersistenceManager.retrieveSearchHistory { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
                
            case .failure(let error):
                self.presentGAPSIAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    private func updateUI(with products: [ProductSearched]) {
        if products.isEmpty {
            self.presentGAPSIAlertOnMainThread(title: "Oops no history", message: "No History?\nTry doing some product search 😁.", buttonTitle: "Ok")
        } else  {
            self.products = products
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}


extension GAPSISearchHistoryListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseID) as! HistoryCell
        let product = products[indexPath.row]
        cell.set(product: product)
        return cell
    }
    
    // If the user taps in the history cell it will show them again the results in the GAPSIProductListVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product    = products[indexPath.row]
        let destVC     = GAPSIProductListVC(product: product.title)
        
        navigationController?.pushViewController(destVC, animated: true)
    }

}
