//
//  MultilineSegmentedControl.swift
//  Example-iOS
//
//  Created by Giorgos Tsiapaliokas on 20/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class MultilineSegmentedControl: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        let segmentedControl = SegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.spacing = 10

        segmentedControl.items = [
            "1", "2", "3", "4", "5",
            "6", "7", "8"
        ]

        self.view.addSubview(segmentedControl)

        self.view.addConstraints([
            self.view.constraint(segmentedControl, attribute1: .CenterX),
            self.view.constraint(segmentedControl, attribute1: .CenterY),
            self.view.constraint(segmentedControl, attribute1: .Width,  multiplier: 0.5),
            self.view.constraint(segmentedControl, attribute1: .Height, multiplier: 0.5)
        ])
    }

}
