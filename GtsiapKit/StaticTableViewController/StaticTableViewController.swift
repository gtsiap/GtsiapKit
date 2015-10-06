//
//  StaticTableViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 06/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class StaticRow {
    public var didSelectRow: (() -> ())?

    public init() {}
}

public class StaticTextRow: StaticRow {
    let text: String
    let detailText: String?

    public init(text: String, detailText: String?) {
        self.text = text
        self.detailText = detailText
    }
}

public class StaticSection {

    private(set) var rows: [StaticRow] = [StaticRow]()

    public init() {}

    public func addRow(text: String, detailText: String? = nil) -> StaticRow {
        let row = StaticTextRow(text: text, detailText: detailText)

        self.rows.append(row)

        return row
    }

}

public class StaticTableViewController: UITableViewController {

    public var staticSections: [StaticSection] = [StaticSection]()

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "staticTextCell")
    }

    // MARK: - Table view data source

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.staticSections.count
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staticSections[section].rows.count
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        let cellRow = self.staticSections[indexPath.section].rows[indexPath.row]
        if let c = cellRow as? StaticTextRow {
            cell = tableView.dequeueReusableCellWithIdentifier("staticTextCell", forIndexPath: indexPath)
            cell.textLabel?.text = c.text
            cell.detailTextLabel?.text = c.detailText
        } else {
            fatalError()
        }

        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.staticSections[indexPath.section].rows[indexPath.row].didSelectRow?()
    }

}
