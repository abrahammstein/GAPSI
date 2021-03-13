//
//  UIViewController+Ext.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

extension UIViewController {
    
    func presentGAPSIAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GAPSIAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
