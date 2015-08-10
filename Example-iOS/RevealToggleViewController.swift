//
//  RevealToggleViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/4/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class RevealToggleViewController: UIViewController {

    private lazy var feedbackManager: FeedbackManager = {
        let manager = FeedbackManager(viewController: self)
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Search,
            target: nil,
            action: nil
        )
    }

    @IBAction func toggleButton(sender: UIButton) {
        revealNavigationController().hideRevealBarItem = !revealNavigationController().hideRevealBarItem
    }

    @IBAction func showMailComposer(sender: UIButton) {
        self.feedbackManager.showMailComposer()
    }

}
