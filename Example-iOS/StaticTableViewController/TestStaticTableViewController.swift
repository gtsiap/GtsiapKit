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

class TestStaticTableViewController: FormsTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let section = FormSection()
        
        
        section.addRow(StaticForm(text: "Operations")).didSelectRow = {
            let vc = UIStoryboard(name: "Operations", bundle: nil)
                .instantiateInitialViewController()!
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "Activity Indicator")).didSelectRow = {
            let vc = UIStoryboard(name: "ActivityIndicator", bundle: nil)
                .instantiateViewControllerWithIdentifier("activityIndicator")
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "Activity Indicator Table View")).didSelectRow = {
            let vc = UIStoryboard(name: "ActivityIndicator", bundle: nil)
                .instantiateInitialViewController()!
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "Toast")).didSelectRow = {
            let vc = UIStoryboard(name: "Toast", bundle: nil)
                .instantiateViewControllerWithIdentifier("toastView")
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "Toast Table View")).didSelectRow = {
            let vc = UIStoryboard(name: "Toast", bundle: nil)
                .instantiateInitialViewController()!
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "SearchView")).didSelectRow = {
            let vc = UIStoryboard(name: "SearchView", bundle: nil)
                .instantiateInitialViewController()!
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "Multiline Segmented Control")).didSelectRow = {
            let vc = UIStoryboard(name: "MultilineSegmentedControl", bundle: nil)
                .instantiateInitialViewController()!
            self.pushViewController(vc)
        }
        
        section.addRow(StaticForm(text: "Animal TableViewController via Storyboard")).didSelectRow = {
            let vc = UIStoryboard(name: "AnimalTableViewController", bundle: nil)
                .instantiateInitialViewController()!
            self.pushViewController(vc)
        }
        
        self.formSections = [section]
    }
    
    private func pushViewController(ViewController: UIViewController) {
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
}
