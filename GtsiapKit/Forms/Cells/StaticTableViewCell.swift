//
//  StaticTableViewCell.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class StaticForm: FormViewable {

    public var required: Bool = false
    public var resultChanged: ((AnyObject?) -> ())?
    let text: String
    let detailText: String?

    public init(text: String, detailText: String? = nil) {
        self.text = text
        self.detailText = text
    }

    public func validate() throws {}
}
