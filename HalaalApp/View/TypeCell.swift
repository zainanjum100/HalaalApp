//
//  TypeCell.swift
//  HalaalApp
//
//  Created by ZainAnjum on 12/06/2018.
//  Copyright © 2018 ZainAnjum. All rights reserved.
//

import UIKit
class TypeCell: BaseClass {
    let IconimageView : UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(icon: .FAInfoCircle, size: CGSize(width: 30, height: 30))
        return imageView
    }()
    let titleLabel : UILabel = {
    let Label = UILabel()
        Label.text = "       "
        Label.backgroundColor = UIColor.darkGray
        Label.adjustsFontSizeToFitWidth = true
        Label.textAlignment = .center
        return Label
    }()
    override func setupViews() {
        addSubview(IconimageView)
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0(30)]", views: IconimageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        
        addConstraintsWithFormat(format: "V:|[v0(30)][v1]|", views: IconimageView, titleLabel)
    }
}
class BaseClass: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
