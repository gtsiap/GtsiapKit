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
import MessageUI
import Device

public class FeedbackManager: NSObject {

    public static var recipients: [String] = [String]()
    public static var ccRecipients: [String] = [String]()

    public weak var viewController: UIViewController!

    public private(set) var mailViewController: MFMailComposeViewController!

    private var mailBody: String {
        let bundle = Bundle.main

        let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        let appName = "Application name: \(name)"

        let version  =  bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        let appVersion = "Application version: \(version)"

        let device = "Device: \(Device.type().rawValue) (\(Device.version().rawValue))"
        let software = "iOS version: \(UIDevice.current.systemVersion)"


        var body = appName
        body += "\n"

        body += appVersion
        body += "\n"

        body += device
        body += "\n"

        body += software
        body += "\n"

        return body
    }

    public init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
    }

    public func showMailComposer() {
        if MFMailComposeViewController.canSendMail() {
            self.mailViewController = initMailComposer()
            viewController.present(self.mailViewController, animated: true, completion: nil)
            return
        }

        var message = "It seems that you haven't configured your mail account. "
        message += "If you want to send feedback to us you need a mail account."

        let alert = UIAlertController(
            title: "Mail Error",
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action in
           alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(action)

        viewController.present(alert, animated: true, completion: nil)
    }

    private func initMailComposer() -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()

        vc.mailComposeDelegate = self

        vc.setToRecipients(FeedbackManager.recipients)
        vc.setCcRecipients(FeedbackManager.ccRecipients)
        vc.setMessageBody(self.mailBody, isHTML: false)

        return vc
    }

}

extension FeedbackManager: MFMailComposeViewControllerDelegate {


    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {


        if let _ = error {

            let alert = UIAlertController(
                title: "Mail Error",
                message: error!.localizedDescription,
                preferredStyle: .alert
            )

            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action in
                self.viewController.dismiss(animated: true, completion: nil)
            }

            alert.addAction(action)

            self.viewController.present(alert, animated: true, completion: nil)
        }

        self.viewController.dismiss(animated: true, completion: nil)
    }

}
