// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/**
    A multi section TableView Controller with multiple rows and multiple cell identifiers
    - NOTE: the cells must comfort to the TableViewCellable protocol
 */
public class BaseTableViewController: UITableViewController {
    var dataSourceable: TableViewDataSourceType!

    public var useAutoHeightCells: Bool { return true }
    public var performLoadDataOnLoad: Bool { return true }
    
    /**
        If its true then 
        * when viewWillAppear gets called
        the viewController will call reloadData
        
        * when loadData gets called needsReload will be true.
          It's the user's responsibility to do any clean up and to fetch
          new data.
     */
    public var needsReload: Bool = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSourceForTableViewController(DataSourceMaker(tableViewController: self))
        
        if self.useAutoHeightCells {
            self.tableView.estimatedRowHeight = 50
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
        
        if shouldPerformPullToRefresh() {
        
            self.refreshControl = UIRefreshControl()
        
            self.refreshControl?.addTarget(
                self,
                action: "refreshControlValueDidChange",
                forControlEvents: .ValueChanged
            )
        
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull Me..")
            
            // we must call reloadData because the refresh control is messing up
            // the UI internals of UITableViewController
            self.tableView.reloadData()
            self.refreshControl?.alpha = 0
        }
        
        if self.performLoadDataOnLoad {
            performLoadData() { self.refreshControl?.alpha = 1.0 }
        } else {
            self.refreshControl?.alpha = 1.0
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.needsReload {
            performLoadData()
        }
    }
    
    public func dataSourceForTableViewController(make: DataSourceMaker) {
        fatalError("Missing Implementation: \(self.dynamicType)")
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSourceable.numberOfSections()
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceable.numberOfRowsInSection(section)
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.dataSourceable.cellForRowAtIndexPath(self, indexPath: indexPath)
    }
    
}
