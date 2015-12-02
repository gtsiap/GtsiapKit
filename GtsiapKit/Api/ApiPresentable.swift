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

private struct ApiPresentableKey {
    static var networkIndicatorKey = "apipresentable_network_indicator"
    static var showNetworkActivityKey = "apipresentable_show_network_activity_key"
    static var viewControllerKey = "apipresentable_view_controller_key"
    static var toastKey = "apipresentable_toast_key"
}

public protocol ApiPresentable: class {}

// MARK: View Controller
extension ApiPresentable {
    private var view: UIView? {
        return self.viewController?.view
    }
    
    /**
        - parameter viewContoller: The viewController in which we will operate
        - returns: Self, in order to be used as a chainable method
     */
    public func viewControllerForTask(viewController: UIViewController) -> Self {
        self.viewController = viewController
        
        return self
    }
    
    public var viewController: UIViewController? {
        get {
            return objc_getAssociatedObject(
                self,
                &ApiPresentableKey.viewControllerKey
            )as? UIViewController
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &ApiPresentableKey.viewControllerKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
}

// MARK: Network Activity
extension ApiPresentable {

    /**
        - parameter viewContoller: hides the network activity
        - returns: Self, in order to be used as a chainable method
     */
    public func hideNetworkActivity() -> Self {
        self.showNetworkActivity = false
        return self
    }
    
    /**
        Call this method in order to **start** the network activity
        If **showNetworkActivity** is false this method has no effect
     */
    public func startNetworkActivity() {
        if self.showNetworkActivity && self.view != nil {
            self.view?.addSubview(self.networkIndicator)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            self.networkIndicator.startAnimating()
        }
    }
    
    /**
        Call this method in order to **stop** the network activity
     */
    public func stopNetworkActivity() {
        self.networkIndicator.stopAnimating()
        self.networkIndicator.removeFromSuperview()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /**
        The default value is true
    */
    public var showNetworkActivity: Bool {
        get {
            guard let showNetworkActivity =
                objc_getAssociatedObject(
                    self,
                    &ApiPresentableKey.showNetworkActivityKey
                    )as? Bool
                else { return true }
            
            return showNetworkActivity
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &ApiPresentableKey.showNetworkActivityKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /**
        The network indicator which will be presented
     */
    public var networkIndicator: ActivityIndicatorView {
        get {
            if let indicator =
                objc_getAssociatedObject(
                    self,
                    &ApiPresentableKey.networkIndicatorKey
                )as? ActivityIndicatorView
            {
                return indicator
            }
            
            let indicator = ActivityIndicatorView()
            objc_setAssociatedObject(
                self,
                &ApiPresentableKey.networkIndicatorKey,
                indicator,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            
            return indicator
        }
    }
}

// MARK: Errors
extension ApiPresentable {
    /**
        A UIAlertViewController convenience method
        - parameter error: the localizedDescrition of the error will be shown
        - parameter completed: its called when the user dismisses the alert
     */
    public func showError(error: NSError, completed: (() -> ())? = nil) {
        self.viewController?.showAlert(
            "Server Error",
            message: error.localizedDescription,
            completed: completed
        )
    }
    
    /**
        A UIAlertViewController convenience method
        - parameter error: the localizedDescrition of the error will be shown
        - parameter message: the message of the UIAlertViewController
        - parameter completed: its called when the user dismisses the alert
     */
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
    
    /**
        An appropriate UIAlertViewController for "no intenet connection"
     */
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
}

// MARK: Toast
extension ApiPresentable {
    
    public func toast(text: String) -> Self {
        self.toastView.text = text
        return self
    }
    
    public func showToast() {
        self.view?.addSubview(self.toastView)
        self.toastView.showToast()
    }
    
    private func createToast() -> ToastView {
        let toastView = ToastView()
        
        toastView.toastDidHide = {
            toastView.removeFromSuperview()
        }
        
        return toastView
    }
    
    public var toastView: ToastView {
        get {
            if let toastView =
                objc_getAssociatedObject(
                    self,
                    &ApiPresentableKey.toastKey
                )as? ToastView
            {
                return toastView
            }
            
            let toastView = createToast()
            objc_setAssociatedObject(
                self,
                &ApiPresentableKey.toastKey,
                toastView,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            
            return toastView
        }
    }
}
