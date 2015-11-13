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

public struct TableViewDataSource<
    T: AnyObject, Cell: UITableViewCell
    where Cell: TableViewCellType, Cell.ModelType == T> : TableViewDataSourceType {
    public let sections: [TableViewSection<T, Cell>]
    
    public init(sections: [TableViewSection<T, Cell>]) {
        self.sections = sections
    }
    
    /**
        This is a convenience initializer for create a datasource
        with **only 1 section**.
     */
    public init() {
        self.init(sections: [TableViewSection<T, Cell>]())
    }
    
    public func numberOfSections() -> Int {
        return self.sections.count
    }
        
    public func numberOfRowsInSection(sectionIndex: Int) -> Int {
        return self.sections[sectionIndex].items.count
    }
    
    public func cellForRowAtIndexPath(tableViewController: UITableViewController, indexPath: NSIndexPath) -> UITableViewCell {
        let sectionIndex = indexPath.section
        let section = self.sections[sectionIndex]
        
        return section.cellForRow(tableViewController, indexPath: indexPath)
    }
}
