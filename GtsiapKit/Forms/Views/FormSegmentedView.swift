//
//  FormSegmentedView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 23/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormSegmentedView: ObjectFormView<String> {

    public lazy private(set) var segmentedControl:
        SegmentedControl = SegmentedControl()

    public init(title: String, description: String? = nil) {
        super.init()
        self.mainView = self.segmentedControl
        self.fillHeightForMainView = true

        self.segmentedControl.valueDidChange = { value in
            self.result = value
        }

        self.valueForMainView = { value in
            guard let
                stringValue = value as? String
            else { return }
            self.segmentedControl.value = stringValue
        }

        configureView(title, description: description)
    }

}
