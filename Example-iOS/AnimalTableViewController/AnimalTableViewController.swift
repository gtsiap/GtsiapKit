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

class Animal {
    var name: String!
}

class AnimalTableViewController: BaseTableViewController {
    
    private var animalSection = TableViewSection<Animal, AnimalTableViewCell>()
    
    private lazy var cat: Animal = {
        let animal = Animal()
        animal.name = "cat"
        return animal
    }()
    
    private lazy var dog: Animal = {
        let animal = Animal()
        animal.name = "Dog"
        return animal
    }()
    
    override var performLoadDataOnLoad: Bool { return false }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ApiManager.sharedManager.baseUrl = "https://httpbin.org/"
        
        self.animalSection.resetItems([dog, cat])
        self.tableView.reloadData()
    }
    
    override func dataSourceForTableViewController(make: DataSourceMaker) {
        let sections: [TableViewSection<Animal, AnimalTableViewCell>] = [self.animalSection]
        make.setUpDataSourceFromSections(sections)
    }
    
    override func loadData(needsReload: Bool, completed: () -> ()) {
        
        guard needsReload else {
            completed()
            return
        }

        let url = NSURL(string: ApiManager.sharedManager.baseUrl + "get")
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = "GET"
        ApiManager.sharedManager.task(urlRequest) { data in
            let elephant = Animal()
            elephant.name = "elephant"
            
            self.animalSection.resetItems([
                self.cat,
                self.dog,
                elephant
            ])
            completed()
        }.viewControllerForTask(self).start()
    }
    
    override func pullToRefresh(completed: () -> ()) {
        super.pullToRefresh() { completed() }
    } 
}
