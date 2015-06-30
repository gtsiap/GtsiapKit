//
//  RevealNavigationController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 6/12/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public enum RevealMenuSide {
    case Left
    case Right
}

public class RevealNavigationController: UINavigationController {
    // TODO revealBarItem should be lazy like var revealBarItem: UIBarButtonItem = {.....} ()
    public var revealBarItem: UIBarButtonItem!
    public var menuViewController: UIViewController!
    
    public var revealMenuSide: RevealMenuSide = RevealMenuSide.Left
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showMenu() {
        let currentViewController = self.topViewController
        let mainView = currentViewController.view
        
        if mainView is ContainerView2 {
            // the user clicked for the second time the reveal icon so,
            // he wants to hide the menu view
            hideMenu()
            return
        }
        
        let containerView = ContainerView2(frame: mainView.frame)
        currentViewController.view = containerView
        
//        self.menuViewController.didMoveToParentViewController(currentViewController)

        currentViewController.addChildViewController(self.menuViewController)
        self.menuViewController.didMoveToParentViewController(currentViewController)
        
        containerView.mainView = mainView
        containerView.menuView = self.menuViewController.view
        containerView.menuDidHide = {
            self.restoreViewHierarchy()
        }
        
        containerView.showMenuView()
    }
    
    func hideMenu() {
        let (isContainerView: Bool, containerView: ContainerView2?) = checkForContainerView()
        
        if !isContainerView {
            return
        }
        
        containerView?.hideMenuView()
    }
    
    private func restoreViewHierarchy() {
        let (isContainerView: Bool, containerView: ContainerView2?) = checkForContainerView()
        
        
        // this check is a bit too much but better safe than sorry.
        if !isContainerView {
            return
        }
        
        let mainView = containerView?.mainView
        mainView?.removeFromSuperview()
        self.topViewController.view = mainView
        
        self.menuViewController.removeFromParentViewController()
    }
    
    private func checkForContainerView() -> (Bool, ContainerView2?) {
        let currentViewController = self.topViewController
        var isContainerView: Bool = false
        
        if currentViewController.view is ContainerView2 {
            isContainerView = true
        }
        
        return (isContainerView, currentViewController.view as? ContainerView2)
    }
}

extension RevealNavigationController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let frameworkBundle = NSBundle(forClass: RevealNavigationController.self)
        let revealIcon = UIImage(named: "reveal-icon", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)
        
        self.revealBarItem = UIBarButtonItem(image: revealIcon, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("showMenu"))
        
        viewController.navigationItem.rightBarButtonItem = revealBarItem
    }
}

extension UIViewController {
    public func revealNavigationController() -> RevealNavigationController {
        return self.navigationController as! RevealNavigationController
    }
}

class Container : UIView {
    
    weak var menuViewController: UIViewController!
    weak var targetViewController: UIViewController!
    
    // MARK: private vars
    private var targetView: UIView!
    private var menuOffset: CGFloat {
        return self.targetViewController.view.bounds.width / 2.2
    }
    
    // MARK: initializers
    init(targetViewController: UIViewController, menuViewController: UIViewController) {
        self.menuViewController = menuViewController
        self.targetViewController = targetViewController
        super.init(frame: self.targetViewController.view.frame)
      //  changeUIViewHierarchy()
    }

    deinit {
        println("Cleaning up")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI hierarchy
    private func changeUIViewHierarchy() {
        self.targetView = self.targetViewController.view
        
        addSubview(self.menuViewController.view)
        addSubview(self.targetView)
        
        self.targetViewController.view.addSubview(self)
    }
    
    // MARK: gesture recognizers
    private func targetViewAddGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("targetViewTapped:"))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.targetView.addGestureRecognizer(singleTap)
        self.targetView.userInteractionEnabled = true
    }
    
    private func targetViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended) {
            hideMenuView()
        }
    }
    
    // MARK: Animations
    private func hideMenuView() {
        UIView.animateWithDuration(1.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.targetView.layer.shadowOpacity = 0.0
                self.targetView.layer.shadowRadius = 0
                self.targetView.layer.shadowOffset = CGSize(width: 0, height: 0);
                self.targetView.frame.origin.x = -self.frame.height
                self.targetView.frame.origin.x = 0
        }, completion: nil)
        self.targetViewController.view = nil
    }
    
    private func showMenuView() {
        UIView.animateWithDuration(1.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.targetView.layer.shadowOpacity = 0.5
                self.targetView.layer.shadowRadius = 10
                self.targetView.layer.shadowOffset = CGSize(width: -10, height: 10);
                self.targetView.layer.masksToBounds = false;
                //self.targetView.frame.origin.x = 0
                self.targetView.frame.origin.x = self.frame.origin.x + self.menuOffset
        }, completion: nil)
    }
}




//
//  ContainerView.swift
//  atlas-ios
//
//  Created by Giorgos Tsiapaliokas on 5/7/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//


class ContainerView : UIView {
    
    // MARK: private vars
    private var menuView: UIView!
    private weak var mainView: UIView!
    private weak var parentViewController: UIViewController!
    private var menuOffset: CGFloat!
    private var menuViewController: UIViewController!
    
    // MARK: initializers
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        mainView = parentViewController.view
        menuOffset = CGFloat(mainView.bounds.width / 2.2)
        super.init(frame: mainView.frame)
        mainViewAddGestureRecognizer()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("You the other initializer:)")
    }
    
    // MARK: funcs
    func createMenuView() {
        
        menuViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Menu") as! UIViewController
        parentViewController.addChildViewController(menuViewController)
        menuViewController.didMoveToParentViewController(parentViewController)
        
        menuView = menuViewController.view
        
        let navigationBarHeight = parentViewController.navigationController?.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let menuY = navigationBarHeight! + statusBarHeight
        
        menuView.frame =  CGRect(x: -frame.height, y: menuY, width: menuOffset, height: frame.height)
        insertSubview(menuView, belowSubview: mainView)
    }
    
    func doAnimation() {
        if let mv = mainView {
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.mainView.layer.shadowOpacity = 0.5
                self.mainView.layer.shadowRadius = 10
                self.mainView.layer.shadowOffset = CGSize(width: -10, height: 10);
                self.mainView.layer.masksToBounds = false;
                self.menuView.frame.origin.x = 0
                self.mainView.frame.origin.x = self.frame.origin.x + self.menuOffset
                }, completion: nil)
        }
    }
    
    // MARK: private funcs
    private func mainViewAddGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("mainViewTapped:"))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        mainView.addGestureRecognizer(singleTap)
        mainView.userInteractionEnabled = true
    }
    
    @objc private func mainViewTapped(recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.Ended) {
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.mainView.layer.shadowOpacity = 0.0
                self.mainView.layer.shadowRadius = 0
                self.mainView.layer.shadowOffset = CGSize(width: 0, height: 0);
                self.menuView.frame.origin.x = -self.frame.height
                self.mainView.frame.origin.x = 0
                }, completion: nil)
        }
    }
}

public extension UIViewController {
    
    func createSidebarButtonItem() {
        let button = UIBarButtonItem(title: "SidebarButton", style: .Plain, target: self, action: Selector("showSidebarMenu"))
        navigationItem.leftBarButtonItem = button
    }
    
    func showSidebarMenu() {
        if view is ContainerView {
            return
        }
        
        let containerView = ContainerView(parentViewController: self)
        
        let mainView = view
        view = containerView
        containerView.addSubview(mainView)
        // containerView.layoutSubviews()
        //mainView.layoutSubviews()
        //mainView.needsUpdateConstraints()
        //mainView.updateConstraints()
        // containerView.updateConstraints()
        // return
        containerView.createMenuView()
        containerView.doAnimation()
        
        println(mainView.subviews)
        println("Sidebar did appear")
    }
    
    func sideBarWillDisappear() {
        view = nil
        
        println("Sidebar will disappear")
    }
    
}