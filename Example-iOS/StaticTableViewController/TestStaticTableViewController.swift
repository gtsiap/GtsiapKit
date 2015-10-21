//
//  TestStaticTableViewController.swift
//  Example-iOS
//
//  Created by Giorgos Tsiapaliokas on 06/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class TestStaticTableViewController: FormsTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let section = FormSection()
        let row = FormRow(type: FormType.ReadOnly(text: "test1", detailText: nil))
        row.didSelectRow = {
            let vc = MultilineSegmentedControl()
            self.navigationController?.pushViewController(vc, animated: true)
        }

        section.rows.append(row)

        self.formSections = [section]
    }
}
