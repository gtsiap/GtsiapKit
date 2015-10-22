//
//  FormRow.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormRow {
    public let formView: FormViewable

    public var didSelectRow: (() -> ())?
    public var result: AnyObject? {
        didSet {
            self.didUpdateResult?(result: self.result)
        }
    }

    public var didUpdateResult: ((result: AnyObject?) -> ())?

    var accessoryType: UITableViewCellAccessoryType {
        guard let _ = self.didSelectRow else {
            return .None
        }

        return UITableViewCellAccessoryType.DisclosureIndicator
    }

    public init(formView: FormViewable) {
        self.formView = formView
        self.formView.resultChanged = { result in
            self.result = result
        }
    }

}
