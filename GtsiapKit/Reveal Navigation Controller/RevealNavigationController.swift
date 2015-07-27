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

    public lazy var revealBarItem: UIBarButtonItem = {
        let frameworkBundle = NSBundle(forClass: RevealNavigationController.self)
        let revealIcon = UIImage(named: "reveal-icon", inBundle: frameworkBundle, compatibleWithTraitCollection: nil)

        return UIBarButtonItem(
            image: revealIcon,
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("showMenu")
        )
    }()

    public var menuViewController: UIViewController!

    public var revealMenuSide: RevealMenuSide = RevealMenuSide.Right

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

        if mainView is ContainerView {
            // the user clicked for the second time the reveal icon so,
            // he wants to hide the menu view
            hideMenu()
            return
        }

        mainView.setTranslatesAutoresizingMaskIntoConstraints(false)

        let containerView = ContainerView()
        currentViewController.view = containerView

        containerView.menuView = self.menuViewController.view
        containerView.mainView = mainView

        containerView.menuDidHide = {
            self.restoreViewHierarchy()
        }

        containerView.showMenuView()
    }

    func hideMenu() {
        let (isContainerView: Bool, containerView: ContainerView?) = checkForContainerView()

        if !isContainerView {
            return
        }

        containerView?.hideMenuView()
    }

    private func restoreViewHierarchy() {
        let (isContainerView: Bool, containerView: ContainerView?) = checkForContainerView()


        // this check is a bit too much but better safe than sorry.
        if !isContainerView {
            return
        }

        let mainView = containerView?.mainView
        mainView?.setTranslatesAutoresizingMaskIntoConstraints(true)
        mainView?.removeFromSuperview()
        self.topViewController.view = mainView

        self.menuViewController.removeFromParentViewController()
    }

    private func checkForContainerView() -> (Bool, ContainerView?) {
        let currentViewController = self.topViewController
        var isContainerView: Bool = false

        if currentViewController.view is ContainerView {
            isContainerView = true
        }

        return (isContainerView, currentViewController.view as? ContainerView)
    }
}

extension RevealNavigationController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {

        if let barButtonsItems = viewController.navigationItem.rightBarButtonItems as? [UIBarButtonItem] {
            if !contains(barButtonsItems, self.revealBarItem) {
                viewController.navigationItem.rightBarButtonItems?.append(self.revealBarItem)
                return
            }
        }

        viewController.navigationItem.rightBarButtonItem = self.revealBarItem
    }
}

extension UIViewController {
    public func revealNavigationController() -> RevealNavigationController {
        return self.navigationController as! RevealNavigationController
    }
}
