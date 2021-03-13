//
//  GAPSITabBarControllerViewController.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class GAPSITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers                 = [createSearchNC(), createFavoritesNC()]
    }
    
    // This method is going to return a UINavigationController for our Searches
    private func createSearchNC() -> UINavigationController {
        let searchVC        = GAPSISearchVC()
        searchVC.title      = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    // This method is going to return a UINavigationController for our SearchHistory
    private func createFavoritesNC() -> UINavigationController {
        let favoritesListVC         = GAPSISearchHistoryListVC()
        favoritesListVC.title       = "Search History"
        favoritesListVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        return UINavigationController(rootViewController: favoritesListVC)
    }

}
