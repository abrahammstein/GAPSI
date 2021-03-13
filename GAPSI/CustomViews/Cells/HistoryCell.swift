//
//  HistoryCell.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class HistoryCell: UITableViewCell {
    static let reuseID = "HistoryCell"
    let productNameLabel   = GAPSITitleLabel(textAlignment: .center, fontSize: 16)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(product: ProductSearched) {
        productNameLabel.text = product.title
    }
    
    // Configure the NSLayoutConstraint of the productNameLabel
    private func configure() {
        addSubview(productNameLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productNameLabel.heightAnchor.constraint(equalToConstant: 20),
            productNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}
