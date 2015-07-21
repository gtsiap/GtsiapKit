//
//  ActivityIndicatorView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/18/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class ActivityIndicatorViewController: UIViewController {

    private var activityIndicator: ActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator = ActivityIndicatorView()
        self.view.addSubview(self.activityIndicator)
    }

    @IBAction func startAnimating(sender: AnyObject) {
         self.activityIndicator.startAnimating()
    }

    @IBAction func stopAnimating(sender: AnyObject) {
         self.activityIndicator.stopAnimating()
    }

}
