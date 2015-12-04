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
import GtsiapKit

class RedditTableViewController: FetchMoreTableViewController {
    
    private var threadSection = TableViewSection<Thread, RedditTableViewCell>()
    private let task: ApiObjectTask<Thread> = ApiManager.sharedManager.task()
    
    override var performLoadDataOnLoad: Bool { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiManager.sharedManager.baseUrl = "https://www.reddit.com/r/swift.json"
        self.task.taskResultProvider.objectTransformer = { (JSON) -> ([Thread]?) in
            var threads = [Thread]()
            guard let
                data = JSON["data"] as? [String : AnyObject],
                children = data["children"] as? [[String : AnyObject]],
                after = data["after"] as? String
            else { return threads }

            for child in children {
                guard let
                    childData = child["data"] as? [String : AnyObject],
                    title = childData["title"] as? String
                else { return threads }

                let thread = Thread(name: title, after: after)
                threads.append(thread)
            }
            
            return threads
        }
        
        
        performLoadData()
    }
    
    override func dataSourceForTableViewController(make: DataSourceMaker) {
        make.setUpDataSourceFromSection(self.threadSection)
    }
    
    override func loadData(needsReload: Bool, completed: () -> ()) {
        
        if needsReload {
            self.task.taskResultProvider.needsUpdate()
        }
        
        let url = NSURL(string: ApiManager.sharedManager.baseUrl)
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "GET"
        
        self.task.urlRequest = urlRequest

        self.task.retrieveObject() { result in
            guard let object = result.object else { return }
            self.threadSection.resetItems(object)
            completed()
        }.viewControllerForTask(self).start()

    }
    
    override func fetchMore(finished: () -> ()) {
        guard let
            indexPath = self.tableView.indexPathsForVisibleRows?.last
        else { return }

        self.threadSection.appendItems() { completed in
            let after = self.threadSection.items[indexPath.row].after
            let url = NSURL(string: ApiManager.sharedManager.baseUrl + "?after=\(after)")
            let urlRequest = NSMutableURLRequest(URL: url!)
            
            self.task.fetchMore(urlRequest) { result in
                let newThreads = result.fetchMoreObjects ?? [Thread]()
                completed(items: newThreads)
                finished()
            }.viewControllerForTask(self).start()
        }
    }

}
