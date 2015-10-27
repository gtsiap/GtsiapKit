//
//  FormSwitchView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 27/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormSwitchView: ObjectFormView<Bool> {

    public lazy private(set) var switcher: UISwitch = {
        let switcher = UISwitch()

        switcher.addTarget(
            self,
            action: "switchValueDidChange",
            forControlEvents: .ValueChanged
        )

        return switcher
    }()

    public init(title: String, description: String? = nil) {
        super.init()
        self.mainView = self.switcher

        self.placeMainViewInRightSide = true

        self.valueForMainView = { value in
            guard let
                boolValue = value as? Bool
            else { return }

            self.switcher.enabled = boolValue
        }

        configureView(title, description: description)
    }

    @objc private func switchValueDidChange() {
        self.result = self.switcher.enabled
    }
}
