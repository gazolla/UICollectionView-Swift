//
//  CardView.swift
//  UICollectionView-Swift
//
//  Created by Gazolla on 22/10/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var label:UILabel
    
    override init(frame: CGRect) {
        self.label               = UILabel()
        self.label.font          = UIFont.boldSystemFontOfSize(24)
        self.label.textAlignment = NSTextAlignment.Center
        super.init(frame: frame)

        self.addSubview(self.label)
        self.backgroundColor    = UIColor.whiteColor()
        self.layer.cornerRadius = 10.0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }


}
