//
//  CardView.swift
//  UICollectionView-Swift
//
//  Created by Gazolla on 22/10/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    lazy var label:UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.textAlignment = NSTextAlignment.center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.label)
        self.backgroundColor    = UIColor.white()
        self.layer.cornerRadius = 10.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }


}
