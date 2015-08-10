//
//  ToastTableViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/21/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class ToastTableViewController: UITableViewController {

    let data = [1, 2, 3, 4, 5, 6]

    override func viewDidLoad() {
        super.viewDidLoad()

        let toastView = ToastView()
        toastView.text = "1,2,3,5,6,7,8"
        self.tableView.addSubview(toastView)
        toastView.showToast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell


        cell.textLabel?.text = String(self.data[indexPath.row])
        return cell
    }
}
