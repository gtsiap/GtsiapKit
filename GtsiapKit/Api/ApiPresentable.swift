//
//  ApiPresentable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/23/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public protocol ApiPresentable: class {

    var viewController: UIViewController? { get set }
    var toastView: ToastView { get set }
    var showNetworkActivity: Bool { get set }
    var networkIndicator: ActivityIndicatorView { get set }
}


extension ApiPresentable {

    private var view: UIView? {
        return self.viewController?.view
    }

    // MARK: chainable
    public func hideNetworkActivity() -> Self {
        self.showNetworkActivity = false
        return self
    }

    public func viewControllerForTask(viewController: UIViewController) -> Self {
        self.viewController = viewController

        return self
    }

    public func toast(text: String) -> Self {
        self.toastView.text = text
        return self
    }

    // MARK: funcs

    public func showToast() {
        self.view?.addSubview(self.toastView)
        self.toastView.showToast()
    }

    public static func createToast(text: String? = nil) -> ToastView {
        let toastView = ToastView()

        if let toastText = text {
            toastView.text = toastText
        }

        toastView.toastDidHide = {
            toastView.removeFromSuperview()
        }

        return toastView
    }

    public func showError(error: NSError) {
        let alertController = UIAlertController(
            title: "Server Error",
            message: "A server error occured",
            preferredStyle: .Alert
        )

        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
            self.viewController?.dismissViewControllerAnimated(true, completion: nil)
        }

        alertController.addAction(okAction)

        self.viewController?.presentViewController(
            alertController,
            animated: true,
            completion: nil
        )
    }

    public func showNoNetworkConnection() {
        let alertController = UIAlertController(
            title: "Network Connection issue",
            message: "It seems that the device isn't connected to a network",
            preferredStyle: .Alert
        )

        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
            self.viewController?.dismissViewControllerAnimated(true, completion: nil)
        }

        alertController.addAction(okAction)

        self.viewController?.presentViewController(
            alertController,
            animated: true,
            completion: nil
        )

    }

    public func startNetworkActivity() {
        if self.showNetworkActivity && self.view != nil {
            self.view?.addSubview(self.networkIndicator)

            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            self.networkIndicator.startAnimating()
        }
    }

    public func stopNetworkActivity() {
        self.networkIndicator.stopAnimating()
        self.networkIndicator.removeFromSuperview()
    }
}
