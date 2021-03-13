//
//  GAPSIProductListVC.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class GAPSIProductListVC: GAPSILoadingVC {

    var product: String!
    enum Section { case main }
    var products: [Product]           = []
    var filteredProducts: [Product]   = []
    var isSearching                   = false
    var isLoadingMoreProducts         = false
    
    // New for Swift 5 we are using DiffableDataSource
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    init(product: String) {
        super.init(nibName: nil, bundle: nil)
        self.product   = product
        title          = product
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureSearchController()
        configureCollectionView()
        getProducts(product: product)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseID)
    }
    
    private func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "Search for a product"
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    
    // This method would let us get the list of Products that the user is searching for
    private func getProducts(product: String) {
        showLoadingView()
        isLoadingMoreProducts = true
        saveSearchedProduct(product: product)
        NetworkManager.shared.getProducts(for: product) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let products):
                self.updateUI(with: products)
            case .failure(let error):
                self.presentGAPSIAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isLoadingMoreProducts = false
        }
    }
    
    // This helper function will let us update our UICollectionViewController
    private func updateUI(with products: [Product]) {
        self.products.append(contentsOf: products)
        
        if self.products.isEmpty {
            DispatchQueue.main.async {
                self.presentGAPSIAlertOnMainThread(title: "Oops no results!",
                        message: "This search doesn't have any results. Please try a different product 😀.", buttonTitle: "Ok")
            }
            return
        }
        
        self.updateData(on: self.products)
    }
    
    // This method will let us configure our DiffableDataSource for our CollectionView
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, product) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseID, for: indexPath) as! ProductCell
            cell.set(product: product)
            return cell
        })
    }
    
    // This method is required by the DiffableDataSource in order to present a snapshot of products
    private func updateData(on products: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // This method is going to save the String of the current Search
    private func saveSearchedProduct(product: String) {
        let product = ProductSearched(title: product)

        PersistenceManager.updateWith(productSearched: product, actionType: .add) { [weak self] error in
            guard let self = self else { return }

            guard let error = error else {
                return
            }

            self.presentGAPSIAlertOnMainThread(title: "😎", message: error.rawValue, buttonTitle: "Ok")
        }
    }

}

// Extension that will let us filter our list of Products
extension GAPSIProductListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredProducts.removeAll()
            updateData(on: products)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredProducts = products.filter { $0.title.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredProducts)
    }
}

extension GAPSIProductListVC {
    func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
}

extension GAPSIProductListVC: UICollectionViewDelegate {
    
}
