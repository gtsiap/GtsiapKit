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

public struct TableViewSection<T: AnyObject, Cell: TableViewCellType
    where Cell.ModelType == T, Cell: UITableViewCell> {
    
    /**
     The items of this section
     */
    public var items: [T] = [T]()
    
    /**
        - parameter item: the current item of the section for which
                         a cell identifier has been requested
        - parameter indexPath: the current indexPath
        - returns: returns the cell identifier that it will be used
                   for the cell reuse
     */
    public typealias CellIdentifierHandler = (item: T, indexPath: NSIndexPath) -> String
    public let cellIdentifierHandler: CellIdentifierHandler
    
    /**
        - parameter items: The items of this section
        - parameter cellIdentifierHandler: the cellIdentifierHandler handler
     */
    public init(items: [T], cellIdentifierHandler: CellIdentifierHandler) {
        self.items = items
        self.cellIdentifierHandler = cellIdentifierHandler
    }
    
    /**
        A convenience initializer which sets **myCell** as the cell reuse identifier
     */
    public init(items: [T]) {
        self.init(items: items) { (_, _) -> String in
            return "myCell"
        }
    }
    
    /**
        A convenience initializer which sets **myCell**
        as the cell reuse identifier and it sets an
        empty list for items.
     */
    public init() {
        self.init(items: [T]()) { (_, _) -> String in
            return "myCell"
        }
    }
    
    func cellForRow(tableViewController: UITableViewController, indexPath: NSIndexPath) -> UITableViewCell {
        let rowIndex = indexPath.row
        let item = self.items[rowIndex]
        
        let cellIdentifier = self.cellIdentifierHandler(item: item, indexPath: indexPath)
        let cell = tableViewController.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! Cell
        cell.configure(item)
        cell.gt_viewController = tableViewController
        return cell
    }
}
