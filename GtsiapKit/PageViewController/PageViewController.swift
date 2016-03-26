// Copyright (c) 2015-2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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
