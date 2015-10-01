//
//  ViewController+AlertViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/27/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

extension UIViewController {

    public func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )

        let okAction = UIAlertAction(title: "Ok", style: .Default)
        { alertAction in
            alertVC.dismissViewControllerAnimated(true, completion: nil)
        }

        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }

}
