//
//  FormsTableViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormsTableViewController: UITableViewController {

    public var formSections: [FormSection] = [FormSection]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.registerClass(FormTextFieldCell.self, forCellReuseIdentifier: "formCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ReadOnlyCell")
    }

    // MARK: - Table view data source

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.formSections.count
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.formSections[section].rows.count
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        let cellRow = self.formSections[indexPath.section].rows[indexPath.row]
        switch cellRow.type {
        case .Double:
            let doubleCell = tableView
                .dequeueReusableCellWithIdentifier("formCell", forIndexPath: indexPath)
            as! FormTextFieldCell

            doubleCell.formRow = cellRow
            cell = doubleCell

        case .ReadOnly(let text, let detailText):
            cell = tableView.dequeueReusableCellWithIdentifier("ReadOnlyCell", forIndexPath: indexPath)
            cell.textLabel?.text = text
            cell.detailTextLabel?.text = detailText
        }

        cell.accessoryType = cellRow.accessoryType

        return cell
    }

    // MARK: tableview

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.formSections[indexPath.section].rows[indexPath.row].didSelectRow?()
    }

    public override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cellRow = self.formSections[indexPath.section].rows[indexPath.row]

        switch cellRow.type {
        case .Double:
            return false
        default:
            guard let _ = cellRow.didSelectRow else {
                return false
            }

            return true
        }

    }

    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.formSections[section].title
    }

}
