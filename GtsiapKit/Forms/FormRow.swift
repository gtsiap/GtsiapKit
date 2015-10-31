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

public class FormRow {
    public let formView: FormViewable

    public var didSelectRow: (() -> ())?
    public var result: AnyObject? {
        didSet {
            self.didUpdateResult?(result: self.result)
        }
    }

    public var didUpdateResult: ((result: AnyObject?) -> ())?

    var accessoryType: UITableViewCellAccessoryType {
        guard let _ = self.didSelectRow else {
            return .None
        }

        return UITableViewCellAccessoryType.DisclosureIndicator
    }

    public init(formView: FormViewable) {
        self.formView = formView

        guard let
            view = self.formView as? FormView
        else { return }

        view.resultDidChange = { result in
            self.result = result
        }

    }

}
