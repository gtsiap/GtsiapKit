//
//  NavigationController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/13/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class NavigationController: RevealNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuViewController =
            storyboard?.instantiateViewControllerWithIdentifier("menuViewController") as? RevealTableViewController

        self.revealMenuSide = RevealMenuSide.Right
    }
}
