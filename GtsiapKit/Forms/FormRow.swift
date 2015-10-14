//
//  FormRow.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormRow {
    let type: FormType

    public var didSelectRow: (() -> ())?

    var accessoryType: UITableViewCellAccessoryType {
        switch self.type {
        case .Double:
            return .None
        default:
            guard let _ = self.didSelectRow else {
                return .None
            }

            return UITableViewCellAccessoryType.DisclosureIndicator//.DetailButton
        }
    }

    public init(type: FormType) {
        self.type = type
    }

}

