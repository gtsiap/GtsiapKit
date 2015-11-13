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

class AnimalTableViewController: GTTableViewController {
    
    private var animalSection: TableViewSection<Animal, AnimalTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animal = Animal()
        animal.name = "cat"
        
        let animal2 = Animal()
        animal2.name = "Dog"
        
        self.animalSection = TableViewSection<Animal, AnimalTableViewCell>(items: [animal, animal2])
        
        setUpDataSourceFromSection(self.animalSection)
        
        self.tableView.reloadData()
    }
    
    override func pullToRefresh(completed: () -> ()) {
        dispatch_async(dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL)) {
            sleep(3)
            dispatch_async(dispatch_get_main_queue()) {
                
                let elephant = Animal()
                elephant.name = "elephant"
                self.animalSection.appendItem(elephant)
                self.tableView.reloadData()
                completed()
                
            } // end dispatch main
        } // end dispatch
    } 
}
