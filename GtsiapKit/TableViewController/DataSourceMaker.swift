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
    A helper class which can create a new 
    datasource for the TableViewController
*/
public struct DataSourceMaker {
    private weak var tableViewController: GTTableViewController!
    
    init(tableViewController: GTTableViewController) {
        self.tableViewController = tableViewController
    }
    
    /**
     It setups a new data source for the tableView.
     The tableView will have **only one section**
     - parameter section: the section of the tableView
     */
    public func setUpDataSourceFromSection<T, Cell>(section: TableViewSection<T, Cell>) {
        self.tableViewController.dataSourceable = TableViewDataSource<T, Cell>(
            tableViewController: self.tableViewController,
            sections: [section]
        )
    }
    
    /**
     It setups a new data source for the tableView.
     - parameter sections: the sections of the tableView
     */
    public func setUpDataSourceFromSections<T, Cell>(sections: [TableViewSection<T, Cell>]) {
        self.tableViewController.dataSourceable = TableViewDataSource<T, Cell>(
            tableViewController: self.tableViewController,
            sections: sections
        )
    }
}
