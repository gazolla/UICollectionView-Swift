//
//  CustomCollectionViewCell.swift
//  UICollectionView-Swift
//
//  Created by Gazolla on 22/10/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var cardView:CardView
    
    lazy var swipeLeft:UISwipeGestureRecognizer = {
        let sl  = UISwipeGestureRecognizer(target: self, action: #selector(CustomCollectionViewCell.didSwipeLeft(_:)))
        sl.delegate = self
        sl.numberOfTouchesRequired = 1
        sl.direction = UISwipeGestureRecognizerDirection.left
        return sl
    }()
    
    override init(frame: CGRect) {
        cardView = CardView(frame: frame)
        super.init(frame: frame)
        self.contentView.addSubview(cardView)
        self.addGestureRecognizer(swipeLeft)
    }
    
    func didSwipeLeft(_ gesture:UIGestureRecognizer){
        NSLog("Swipe left")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCardText(_ text:String){
        self.cardView.label.text = text
    }
    
    override func layoutSubviews() {
        self.cardView.frame = self.bounds
    }
}
