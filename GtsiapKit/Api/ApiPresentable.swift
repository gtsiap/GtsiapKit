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

    public func showError(error: NSError, completed: (() -> ())? = nil) {
        self.viewController?.showAlert(
            "Server Error",
            message: error.localizedDescription,
            completed: completed
        )
    }

    public func showError(
        error: String,
        message: String,
        completed: (() -> ())? = nil
    ) {
        self.viewController?.showAlert(
            error,
            message: message,
            completed: completed
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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}
