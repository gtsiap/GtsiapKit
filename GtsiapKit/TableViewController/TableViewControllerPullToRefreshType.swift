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

public protocol TableViewControllerPullToRefreshType {
    func pullToRefreshWillBegin()
    func pullToRefresh(completed: () -> ())
    func pullToRefreshDidEnd()
    func shouldPerformPullToRefresh() -> Bool
}

extension GTTableViewController: TableViewControllerPullToRefreshType {
    
    /**
        It will be called before the 
        pullToRefresh operation begins
     */
    public func pullToRefreshWillBegin() {}
    
    /**
        This is the actual operation.
        Subclasses may override this method.
        **The current implementation will call performLoadData**
        - parameter completed: it **must** be called **after**
                               the operation finishes
     */
    public func pullToRefresh(completed: () -> ()) {
        self.needsReload = true
        performLoadData() {
            completed()
        }
    }
    
    /**
        It will be called after the
        pullToRefresh operation has finished
     */
    public func pullToRefreshDidEnd() {}
    
    /**
        - returns: If true then pullToRefresh will be
                   performed otherwise it won't.
                   The default value is **true**
     */
    public func shouldPerformPullToRefresh() -> Bool {
        return true
    }
    
}