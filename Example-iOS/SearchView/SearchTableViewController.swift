//
//  SearchTableViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/28/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class SearchTableViewController: UITableViewController {

    private let data = ["one", "two", "three"]
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.viewController = self
        searchView.contentView = self.contentView
        searchView.didStartSearching = {
            self.sizeHeaderToFit()
        }

        searchView.didStopSearching = {
            self.sizeHeaderToFit()
        }

        return searchView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "Label1"
        label1.preferredMaxLayoutWidth = self.tableView.frame.width

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "Label2"
        label2.preferredMaxLayoutWidth = self.tableView.frame.width

        contentView.addSubview(label1)
        contentView.addSubview(label2)

        let l1TopConstraint = contentView.constraint(label1, attribute1: .Top)
        let l1CenterXConstraint = contentView.constraint(label1, attribute1: .CenterX)

        let l2TopConstraint = contentView.constraint(label2, attribute1: .Top, view2: label1, attribute2: .Bottom, multiplier: 1.1)
        let l2CenterXConstraint = contentView.constraint(label2, attribute1: .CenterX)
        let l2BottomConstraint = contentView.constraint(label2, attribute1: .Bottom)

        contentView.addConstraints([
            l1TopConstraint,
            l1CenterXConstraint,
            l2TopConstraint,
            l2CenterXConstraint,
            l2BottomConstraint
        ])

        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableHeaderView = self.searchView
        sizeHeaderToFit()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)

        cell.textLabel?.text = self.data[indexPath.row]

        return cell
    }

    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        print("height: \(height)")
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame

        tableView.tableHeaderView = headerView
    }
}
