//
//  PageViewController.swift
//  kimon-ios
//
//  Created by Giorgos Tsiapaliokas on 05/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class PageViewController: UIViewController {

    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController()

        self.addChildViewController(vc)

        self.view.addSubview(vc.view)

        vc.didMoveToParentViewController(self)

        return vc
    }()

    private var topViewController: UIViewController!

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pageViewController.view.frame = CGRect(
            x: self.view.frame.origin.x,
            y: self.topLayoutGuide.length,
            width: self.view.frame.width,
            height: self.view.frame.height - self.bottomLayoutGuide.length
        )
    }

    public func goToNextViewController() {
        self.topViewController = self.viewControllers.removeFirst()
        reloadViewControllers()
    }

    public var viewControllers: [UIViewController] = [UIViewController]() {
        willSet {
            self.viewControllers.forEach() { $0.gt_pageViewController = nil }
        }

        didSet {
            self.viewControllers.forEach() { $0.gt_pageViewController = self }

            if self.topViewController == nil {
                self.topViewController = self.viewControllers.removeFirst()
                reloadViewControllers()
            }
        }
    }

    private func reloadViewControllers() {

        self.pageViewController.setViewControllers(
            [self.topViewController],
            direction: .Forward,
            animated: true
        ) { finished in

        }
    }
}

private struct PageViewControllerAssociatedKeys {
    static var pageViewController = "gtsiapkit_UIViewController_pageViewController"
}

public extension UIViewController {
    var gt_pageViewController: PageViewController? {
        get {
            return objc_getAssociatedObject(
                self,
                &PageViewControllerAssociatedKeys.pageViewController)
            as? PageViewController
        }

        set(vc) {
            objc_setAssociatedObject(
                self,
                &PageViewControllerAssociatedKeys.pageViewController,
                vc,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
