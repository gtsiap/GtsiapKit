//
//  FormSection.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormSection {

    public var rows: [FormRow] = [FormRow]()
    public var title: String?

    public init() {}


    public func addRow(formView: FormViewable) -> FormRow {
        let row = FormRow(formView: formView)
        self.rows.append(row)
        return row
    }
}
