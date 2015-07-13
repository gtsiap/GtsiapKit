//
//  ContainerView.swift
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
            self.mainView.setTranslatesAutoresizingMaskIntoConstraints(false)
            addSubview(self.mainView)

            addConstraint(constraint(self.mainView, attribute1: .Height))
            addConstraint(constraint(self.mainView, attribute1: .Width))

            if doLeftSideAnimation() {
                self.sideConstraint = constraint(self.mainView, attribute1: .Left)
            } else {
                self.sideConstraint = constraint(self.mainView, attribute1: .Right)
            }

            addConstraint(self.sideConstraint!)

            mainViewAddGestureRecognizer()
        }
    }

    var menuView: UIView! {
        didSet {
            self.menuView.setTranslatesAutoresizingMaskIntoConstraints(false)
            addSubview(self.menuView)

            addConstraint(constraint(self.menuView, attribute1: .Top, constant: self.menuY))
            addConstraint(constraint(self.menuView, attribute1: .Width, multiplier: 0.45))
            addConstraint(constraint(self.menuView, attribute1: .Height, constant: -self.menuY))

            if !doLeftSideAnimation() {
              addConstraint(constraint(self.menuView, attribute1: .Right, view2: self, attribute2: .Right))
            }
        }
    }

    // MARK: private vars
    private var sideConstraint: NSLayoutConstraint?

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
        // go back to (0, 0) position
        self.sideConstraint?.constant = 0

        UIView.animateWithDuration(1.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.mainView.layer.shadowOpacity = 0.0
                self.mainView.layer.shadowRadius = 0
                self.mainView.layer.shadowOffset = CGSize(width: 0, height: 0);

                self.mainView.layoutIfNeeded()
            }, completion: { _ in
                self.menuDidHide?()
        })
    }

    func showMenuView() {

        if doLeftSideAnimation() {
            self.sideConstraint?.constant = self.frame.width * 0.45
        } else {
            self.sideConstraint?.constant = -(self.frame.width * 0.45)
        }

        UIView.animateWithDuration(1.5) {
            self.mainView.layer.shadowOpacity = 0.5
            self.mainView.layer.shadowRadius = 5
            self.mainView.layer.shadowColor = UIColor.blackColor().CGColor

            if self.doLeftSideAnimation() {
                self.mainView.layer.shadowOffset = CGSize(width: -10, height: 10)
            } else {
                self.mainView.layer.shadowOffset = CGSize(width: 10, height: 10)
            }

            self.mainView.layoutIfNeeded()
        }
    }

    private func doLeftSideAnimation() -> Bool {
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
