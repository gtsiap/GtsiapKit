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

public class ApiTaskResultProvider<T> {
    var data: [String : AnyObject] =  [String : AnyObject]()

    public typealias TransformerHandler = ((data: [String : AnyObject]) -> ([T]?))?

    public var object: [T]? {
        return self.objectTransformer?(data: self.data)
    }

    public var hasDataAvailable:  Bool {
        if self.data.isEmpty {
            return false
        }

        return true
    }

    public var objectData: [String : AnyObject] {
        return self.data
    }

    public let apiPresentable: ApiPresentable

    public var objectTransformer: TransformerHandler

    init(task: ApiObjectTask<T>) {
        self.apiPresentable = task
    }

    public func needsUpdate() {
        self.data = [String : AnyObject]()
    }


}
