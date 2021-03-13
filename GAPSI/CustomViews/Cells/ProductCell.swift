//
//  ProductCell.swift
//  GAPSI
//
//  Created by Abraham on 3/13/21.
//

import UIKit

class ProductCell: UICollectionViewCell {
    static let reuseID   = "ProductCell"
    let productImageView = GAPSIProductImageView(frame: .zero)
    let productNameLabel = GAPSITitleLabel(textAlignment: .center, fontSize: 16)
    let priceLabel       = GAPSITitleLabel(textAlignment: .center, fontSize: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(product: Product) {
        productImageView.downloadImage(fromURL: product.image)
        productNameLabel.text = product.title
        priceLabel.text       = String(format: "$%.02f", product.price)
    }
    
    // This method will configure our ProductCell
    private func configure() {
        addSubview(productImageView)
        addSubview(productNameLabel)
        addSubview(priceLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 12),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            productNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            priceLabel.heightAnchor.constraint(equalToConstant: 13)
        ])
    }
}
