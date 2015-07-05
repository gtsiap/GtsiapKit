//
//  ContainerView2.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 6/27/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

class ContainerView : UIView {
    var menuDidHide: (() -> ())?
    
    // MARK: views
    var mainView: UIView! {
        didSet {
            addSubview(self.mainView)
            mainViewAddGestureRecognizer()
        }
    }
    
    var menuView: UIView! {
        didSet {
            addSubview(self.menuView)
            println(self.menuY)
            let leftSideRect = CGRect(
                x: self.menuView.frame.origin.x,
                y: self.menuY, //self.menuView.frame.origin.y,
                width: self.menuOffset,
                height: self.menuView.frame.height
            )

            let rightSideRect = CGRect(
                x: self.frame.width - self.menuOffset,
                y: self.menuY,//self.menuView.frame.origin.y,
                width: self.menuOffset,
                height: self.menuView.frame.height
            )

            if doLeftAnimation() {
                self.menuView.frame = leftSideRect
                return
            }
            
            self.menuView.frame = rightSideRect
        }
    }
    
    // MARK: private vars
    private var menuOffset: CGFloat {
        return self.mainView.bounds.width / 2.2
    }
    
    private var menuY: CGFloat {
        if let revealVC = revealNavigationController() {
            return revealVC.navigationBar.frame.height + 
                UIApplication.sharedApplication().statusBarFrame.height
        }
        
        return 0.0
    }
    
    deinit {
        println("Cleaning up")
    }
    
    // MARK: hide/show menu
    func hideMenuView() {
        
        UIView.animateWithDuration(1.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.mainView.layer.shadowOpacity = 0.0
                self.mainView.layer.shadowRadius = 0
                self.mainView.layer.shadowOffset = CGSize(width: 0, height: 0);
                // go back to (0, 0) position
                self.mainView.frame.origin.x = self.frame.origin.x
            }, completion: { _ in
                self.menuDidHide?()
        })
    }
    
    func showMenuView() {
        UIView.animateWithDuration(1.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                // TODO turn the shadow into an extension
                self.mainView.layer.shadowOpacity = 0.5
                self.mainView.layer.shadowRadius = 5
                self.mainView.layer.shadowColor = UIColor.blackColor().CGColor
                
                self.mainView.layer.masksToBounds = false;
                self.bringSubviewToFront(self.mainView)

                if self.doLeftAnimation() {
                    self.mainView.layer.shadowOffset = CGSize(width: -10, height: 10);
                    self.mainView.frame.origin.x += self.menuOffset
                } else {
                    self.mainView.layer.shadowOffset = CGSize(width: 10, height: 10);
                    self.mainView.frame.origin.x -= self.menuOffset
                }
            }, completion: nil)
    }
    
    private func doLeftAnimation() -> Bool {
        if let revealVc = revealNavigationController() {
            if revealVc.revealMenuSide == RevealMenuSide.Right {
                return false
            }
        }
        
        return true
    }
    
    // MARK: gesture recognizers
    private func mainViewAddGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("mainViewTapped:"))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.mainView.addGestureRecognizer(singleTap)
        self.mainView.userInteractionEnabled = true
    }
    
    @objc private func mainViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended) {
            hideMenuView()
        }
    }
}

extension ContainerView {
    func revealNavigationController() -> RevealNavigationController? {
        var revealNavigationController: RevealNavigationController? = nil
        
        if let vc = self.nextResponder() as? UIViewController {
            revealNavigationController = vc.navigationController as? RevealNavigationController
        }
        
        return revealNavigationController
    }
}
