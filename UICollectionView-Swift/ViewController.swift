//
//  ViewController.swift
//  UICollectionView-Swift
//
//  Created by Gazolla on 05/06/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var items = [String]()
    var previousScrollViewYOffset:CGFloat = 0.0

    lazy var collectionView:UICollectionView = {
        var cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = true
        cv.alwaysBounceVertical = true
        cv.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        cv.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return cv
    }()
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        var flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)
        return flow
    }()

    lazy var addButton:UIBarButtonItem = {
        var btn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ViewController.addTapped))
        return btn
    }()
    
    lazy var addAlert:UIAlertView = {
        var alert = UIAlertView()
        alert.delegate = self
        alert.title = "Enter Input"
        alert.addButton(withTitle: "Done")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.addButton(withTitle: "Cancel")
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CollectionView on Swift"
        self.items.append("MyCard")
        self.navigationItem.rightBarButtonItem = self.addButton
        self.view.addSubview(self.collectionView)
        self.navigationController?.hidesBarsWhenVerticallyCompact = true
    }

    func addTapped() {
        self.addAlert.show()
    }
    
    func alertView(_ alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        if (buttonIndex == 0){
            let textField = alertView.textField(at: 0)
            self.collectionView.performBatchUpdates({
                let resultsSize = self.items.count
                self.items.append(textField!.text!)
                var arrayWithIndexPaths = [IndexPath]()
                for i in resultsSize..<resultsSize+1 {
                   arrayWithIndexPaths.append(IndexPath(row: i, section: 0))
                }
                self.collectionView.insertItems(at: arrayWithIndexPaths as [IndexPath])
                },completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.flowLayout.invalidateLayout()
    }

    func updateBarButtonItems(_ alpha:CGFloat){
        if let left = self.navigationItem.leftBarButtonItems {
            for item:UIBarButtonItem in left {
                if let view = item.customView {
                    view.alpha = alpha
                }
            }
        }
        
        if let right = self.navigationItem.rightBarButtonItems {
            for item:UIBarButtonItem in  right {
                if let view = item.customView {
                    view.alpha = alpha
                }
            }
        }

        let black = UIColor.black() // 1.0 alpha
        let semi = black.withAlphaComponent(alpha)
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: semi]

        self.navigationController?.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor.withAlphaComponent(alpha)

    }
    
    func animateNavBarTo(_ y:CGFloat){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            var frame = self.navigationController?.navigationBar.frame
            let alpha:CGFloat = (frame!.origin.y >= y ? 0 : 1)
            frame!.origin.y = y
            self.navigationController?.navigationBar.frame=frame!
            self.updateBarButtonItems(alpha)
        })
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        let width:CGFloat = self.view.bounds.size.width*0.98;
        let height:CGFloat = 150.0;
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.items.count
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.setCardText(self.items[indexPath.row])
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        cell.layer.cornerRadius = 4
        cell.backgroundColor = UIColor.white()
        
        return cell
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.height > (self.view.bounds.height*0.8)) {
            var frame = self.navigationController?.navigationBar.frame
            let size = frame!.size.height - 21;
            let framePercentageHidden = ((20 - frame!.origin.y) / (frame!.size.height - 1));
            let scrollOffset = scrollView.contentOffset.y;
            let scrollDiff = scrollOffset - self.previousScrollViewYOffset;
            let scrollHeight = scrollView.frame.size.height;
            let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
            
            if (scrollOffset <= -scrollView.contentInset.top) {
                frame!.origin.y = 20
            } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
                frame!.origin.y = -size
            } else {
                frame!.origin.y = min(20, max(-size, frame!.origin.y - scrollDiff))
            }
            
            self.navigationController?.navigationBar.frame = frame!
            updateBarButtonItems(1 - framePercentageHidden)
            self.previousScrollViewYOffset = scrollOffset
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate){
            stoppedScrolling()
        }
    }
    
    func stoppedScrolling(){
        let frame = self.navigationController?.navigationBar.frame
        if (frame!.origin.y < 20) {
            animateNavBarTo(-(frame!.size.height - 21))
        }
    }
}
