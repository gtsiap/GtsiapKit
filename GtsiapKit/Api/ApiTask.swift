//
//  ApiTask.swift
//
//  Created by Giorgos Tsiapaliokas on 7/18/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import Alamofire
import UIKit

public class ApiTask {

    public var request: Request!
    weak private(set) var viewController: UIViewController?

    private lazy var showNetworkActivity = true
    private lazy var networkIndicator: ActivityIndicatorView = {
        let activityIndicator = ActivityIndicatorView()

        self.view?.addSubview(activityIndicator)

        return activityIndicator
    }()

    private var toastView: ToastView?

    private var view: UIView? {
        return self.viewController?.view
    }

    public init() {}

    // MARK: funcs

    func requestDidFinishWithError(error: NSError) {
        requestDidFinishCommon()

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

    func requestDidFinishWithNoNetworkConnection() {
        requestDidFinishCommon()

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

    func requestDidFinish() {
        requestDidFinishCommon()
    }

    // MARK: chainable

    public func hideNetworkActivity() -> ApiTask {
        self.showNetworkActivity = false
        return self
    }

    public func start() -> ApiTask {
        if self.showNetworkActivity && self.view != nil {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            self.networkIndicator.startAnimating()
        }

        self.request.resume()

        return self
    }

    public func viewControllerForTask(viewController: UIViewController) -> ApiTask {
        self.viewController = viewController

        return self
    }

    public func toast(text: String) -> ApiTask {
        self.toastView = ApiTask.toast(text)

        return self
    }

    public class func toast(text: String) -> ToastView {
        let toastView = ToastView()
        toastView.text = text
        toastView.toastDidHide = {
            toastView.removeFromSuperview()
        }

        return toastView
    }

    // MARK: private funcs

    private func requestDidFinishCommon() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.networkIndicator.stopAnimating()
        self.networkIndicator.removeFromSuperview()

        if let toast = self.toastView {
            self.view?.addSubview(toast)
            toast.showToast()
        }
    }
}
