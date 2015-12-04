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
    A convenient class which helps with the creation of
    Infinite table views.
    The purpose of the class is to help you with **Simple** tables.
    If you want something more complex feel free to not use this class.
*/
public class FetchMoreTableViewController: BaseTableViewController {
 
    private enum FetchingState {
        case Starting
        case Started
        case Fetching
        case NotFetching
    }
    
    private let fetchingActivityIndicator: UIActivityIndicatorView = {
        let size = UIScreen.mainScreen().bounds.height * 0.2
        let indicator = UIActivityIndicatorView(
            frame: CGRectMake(0, 0, size, size)
        )
        
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.color = UIColor.blackColor()
        indicator.startAnimating()
        return indicator
    }()
    
    private var fetchingState: FetchingState = .NotFetching
   
    override public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        guard let
            indexPath = self.tableView.indexPathsForVisibleRows?.last
        where
                indexPath.row <= (self.tableView.numberOfRowsInSection(indexPath.section) - 1)
        else { return }

        guard case .Starting = self.fetchingState else { return }
        self.fetchingState = .Fetching
        
        fetchMore() {
            self.fetchingState = .NotFetching
            self.tableView.tableFooterView = nil
        }
    }
    
    override public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.tableView.tableFooterView = self.fetchingActivityIndicator
        
        if case .NotFetching = self.fetchingState {
            self.fetchingState = .Starting
        }
    }

    /**
        Fetch your need data here.
        When the "fetch more" operation finished call finished
        - parameter finished: It must be called when the operation finishes
     */
    public func fetchMore(finished: () -> ()) {
        fatalError("Missing Implementation")
    }
}
