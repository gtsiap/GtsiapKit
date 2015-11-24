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

public protocol TableViewControllerReloadType {
    var needsReload: Bool { get set }
    func willLoadData()
    func loadData(needsReload: Bool, completed: () -> ())
    func didLoadData()
}

extension BaseTableViewController: TableViewControllerReloadType {
    /**
        It will be called before the
        loadData operation begins
     */
    public func willLoadData() {
        
    }
    
    /**
        This is the actual operation.
        You **MUST NOT** call this method directly.
        If you need to load data call *performLoadData*
        Subclasses **MUST** override this method
        and they **MUST NOT** call the super implementation.
        - parameter completed: it **must** be called **after**
                               the operation finishes
        - parameter needsReload: If true then the tableView needs to
                                 reset its data and load them again.
                                 If your data are stored in a cache
                                 or somewhere you must retrieve them again.
                                 If false then this method was just called.
                                 Its safe for you to load your *old* data 
                                 from a cache or something.
     */
    public func loadData(needsReload: Bool, completed: () -> ()) {
        fatalError("Implementation is missing")
    }
    
    /**
        It will be called after the
        loadData operation finishes
    */
    public func didLoadData() {}
    
    /**
        You should use this method when you want to reload the
        data of your table.
        - NOTE: **DON'T** used completed. Its an implementation detail
                Instead use *didLoadData*
     */
    public func performLoadData(completed: (() -> ())? = nil) {
        self.needsReload = false

        self.willLoadData()
        
        self.loadData(self.needsReload) {
            self.tableView.reloadDataWithAutoSizingCell()
            self.didLoadData()
            completed?()
        }
        
    }
}
