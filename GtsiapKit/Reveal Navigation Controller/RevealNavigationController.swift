// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public enum RevealMenuSide {
    case Left
    case Right
}

public class RevealNavigationController: UINavigationController {

    public static var animationDuration: Double = 0.7

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

    public var menuDidHide: (() -> ())?
    public var menuWillHide: (() -> ())?

    public var menuDidAppear: (() -> ())?
    public var menuWillAppear: (() -> ())?

    public var menuViewController: RevealTableViewController!

    public var revealMenuSide: RevealMenuSide = RevealMenuSide.Right

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    public var hideRevealBarItem: Bool = false {
        didSet {
            if self.hideRevealBarItem {
                removeRevealBarItem()
            } else {
                addRevealBarItem(self.topViewController!)
            }

        }
    }

    func showMenu() {
        print(self.topViewController?.navigationItem.rightBarButtonItems)

        let currentViewController = self.topViewController!
        self.menuViewController.currentViewController = currentViewController
        self.menuViewController.revealViewController = self

        let mainView = currentViewController.view

        if mainView is ContainerView {
            // the user clicked for the second time the reveal icon so,
            // he wants to hide the menu view
            hideMenu()
            return
        }

        self.menuWillAppear?()

        mainView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = ContainerView()
        currentViewController.view = containerView

        containerView.menuView = self.menuViewController.view
        containerView.mainView = mainView

        containerView.showMenuView() {
            self.menuDidAppear?()
        }
    }

    public func hideMenu(completionHandler: (()->())? = nil) {
        let (isContainerView, containerView): (Bool, ContainerView?) = checkForContainerView()

        if !isContainerView {
            return
        }

        self.menuWillHide?()

        containerView!.menuDidHide = {
            self.restoreViewHierarchy()
            completionHandler?()
        }

        containerView?.hideMenuView()
    }

    private func restoreViewHierarchy() {
        let (isContainerView, containerView): (Bool, ContainerView?) = checkForContainerView()


        // this check is a bit too much but better safe than sorry.
        if !isContainerView {
            return
        }

        let mainView = containerView?.mainView
        mainView?.translatesAutoresizingMaskIntoConstraints = true
        mainView?.removeFromSuperview()
        self.topViewController?.view = mainView
        self.menuDidHide?()
    }

    private func checkForContainerView() -> (Bool, ContainerView?) {
        let currentViewController = self.topViewController!
        var isContainerView: Bool = false

        if currentViewController.view is ContainerView {
            isContainerView = true
        }

        return (isContainerView, currentViewController.view as? ContainerView)
    }

    private func removeRevealBarItem() {
        func removeItem(inout buttons: [UIBarButtonItem], target: UIBarButtonItem) {
            for (index, button) in buttons.enumerate() {
                if button == self.revealBarItem {
                    buttons.removeAtIndex(index)
                    return
                }
            }
        }

        guard var buttonItems =
            self.topViewController?.navigationItem.rightBarButtonItems else
        {
            return
        }

        removeItem(&buttonItems, target: self.revealBarItem)

        self.topViewController?.navigationItem.rightBarButtonItems = buttonItems
    }

    private func addRevealBarItem(viewController: UIViewController) {

        if let barButtonsItems = viewController.navigationItem.rightBarButtonItems {
            if !barButtonsItems.contains(self.revealBarItem) {
                viewController.navigationItem.rightBarButtonItems?.append(self.revealBarItem)
                return
            }
        }

        viewController.navigationItem.rightBarButtonItem = self.revealBarItem
    }
}

extension RevealNavigationController: UINavigationControllerDelegate {

    public func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        addRevealBarItem(viewController)
    }

}

extension UIViewController {
    public func revealNavigationController() -> RevealNavigationController {
        return self.navigationController as! RevealNavigationController
    }
}
