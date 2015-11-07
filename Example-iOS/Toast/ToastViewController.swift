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

class ToastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showLongText(sender: AnyObject) {
       let longText =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean et maximus ante, at tincidunt lectus. Vestibulum " + "maximus, est nec aliquet efficitur, felis metus euismod lorem, ut iaculis erat erat tincidunt arcu. Mauris" + "tempus varius nisi a maximus. Quisque vitae velit sit amet ligula imperdiet consequat eget ut dui. Vivamus sed"
            "sapien non nibh aliquam vestibulum. Cras lacus nunc, pharetra eu urna a, efficitur convallis ante. Morbi a augue ac" +
            "dui porta semper. Nulla tempor dapibus nulla id efficitur. Morbi vitae tincidunt mauris, a fringilla felis. " +
            "Vestibulum semper sem sed neque consectetur, et fermentum leo condimentum. Sed ut mi eu ante porttitor fermentum." +
            "Sed mattis, ipsum suscipit pharetra lobortis, ex ligula tincidunt mi, sed dignissim justo nisi vel tellus."


        createToastView(longText)
    }

    @IBAction func showShortText(sender: AnyObject) {
        let shortText = "123"

        createToastView(shortText)
    }

    private func createToastView(text: String) {
        let toastView = ToastView()
        toastView.text = text
        self.view.addSubview(toastView)
        toastView.toastDidHide = {
            print("Toast did hide")
        }
        toastView.showToast()
    }
}
