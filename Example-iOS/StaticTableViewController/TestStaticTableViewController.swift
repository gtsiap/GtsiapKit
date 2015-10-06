//
//  TestStaticTableViewController.swift
//  Example-iOS
//
//  Created by Giorgos Tsiapaliokas on 06/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class TestStaticTableViewController: StaticTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let section = StaticSection()
        section.addRow("test1").didSelectRow = {
            print("test1")
        }

        section.addRow("test2", detailText: "description ...")
            .didSelectRow = {
                print("test2")
            }

        self.staticSections = [section]
    }
}
