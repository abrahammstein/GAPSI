//
//  GAPSISearchVC.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class GAPSISearchVC: UIViewController {

    let logoImageView       = UIImageView()
    let searchTextField   = GAPSITextField()
    let callToActionButton  = GAPSIButton(backgroundColor: .systemGreen, title: "Search Products")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(searchTextField)
        view.addSubview(callToActionButton)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // This method will let us dismiss the keyboard when the user taps in any place of the view
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushProductsListVC() {
        // If the user didn't type anything we show the GAPSIAlert
        guard let isSearchTextEmpty = searchTextField.text?.isEmpty, !isSearchTextEmpty
            else {
            presentGAPSIAlertOnMainThread(title: "Empty Search", message: "Please enter a product name. We need to know who to look for. 🧐", buttonTitle: "Ok")
            return
            
        }
        
        searchTextField.resignFirstResponder()
        // If everything is okay we present the GAPSIProductListVC
        let productListVC = GAPSIProductListVC()
        productListVC.product = searchTextField.text!
        navigationController?.pushViewController(productListVC, animated: true)
    }
    
    // Configure NSLayoutConstraint for logoImageView
    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.eCommerceLogo
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // Create NSLAyoutConstraint for searchTextField
    private func configureTextField() {
        searchTextField.delegate = self
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Configure NSLayoutConstraint for callToActionButton
    private func configureCallToActionButton() {
        callToActionButton.addTarget(self, action: #selector(pushProductsListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

// We need this extension in order to implement to the UITextFieldDelegate
extension GAPSISearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushProductsListVC()
        return true
    }
}
