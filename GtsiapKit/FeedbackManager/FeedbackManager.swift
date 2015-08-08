//
//  FeedbackViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/8/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import MessageUI

public class FeedbackManager: NSObject, MFMailComposeViewControllerDelegate {

    public static var recipients: [String] = [String]()
    public static var ccRecipients: [String] = [String]()

    public weak var viewController: UIViewController!

    public private(set) var mailViewController: MFMailComposeViewController!

    private var mailBody: String {
        let bundle = NSBundle.mainBundle()

        let name = bundle.objectForInfoDictionaryKey("CFBundleName") as? String ?? ""
        let appName = "Application name: \(name)"

        let version  =  bundle.objectForInfoDictionaryKey("CFBundleVersion") as? String ?? ""
        let appVersion = "Application version: \(version)"

        let desc = hardwareDescription() ?? ""

        let device = "Device: \(desc) (\(hardwareString()))"
        let software = "iOS version: \(UIDevice.currentDevice().systemVersion)"


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
            viewController.presentViewController(self.mailViewController, animated: true, completion: nil)
            return
        }

        var message = "It seems that you haven't configured your mail account. "
        message += "If you want to send feedback to us you need a mail account."

        let alert = UIAlertController(
            title: "Mail Error",
            message: message,
            preferredStyle: .Alert
        )

        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
           alert.dismissViewControllerAnimated(true, completion: nil)
        }

        alert.addAction(action)

        viewController.presentViewController(alert, animated: true, completion: nil)
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


    public func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {


        if let mailError = error {

            let alert = UIAlertController(
                title: "Mail Error",
                message: error.localizedDescription,
                preferredStyle: .Alert
            )

            let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                self.viewController.dismissViewControllerAnimated(true, completion: nil)
            }

            alert.addAction(action)

            self.viewController.presentViewController(alert, animated: true, completion: nil)
        }

        self.viewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
