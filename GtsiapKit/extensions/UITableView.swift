//
//  UITableView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 20/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public extension UITableView {

    // https://github.com/smileyborg/TableViewCellWithAutoLayoutiOS8/issues/10

    public func reloadDataWithAutoSizingCell() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }

}
