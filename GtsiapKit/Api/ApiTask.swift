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
import Alamofire

public class ApiTask: Taskable {

    public typealias ApiTaskHandler = (data: [String : AnyObject]) -> ()

    public var offlineDelegate: RequestableOfflineDelegate?
    public var taskDidFinish: ((task: ApiTask) -> ())?
    public var urlRequest: URLRequestConvertible?

    // Internal used for ApiGroup
    var taskFinished: (() -> ())?

    var request: Request?

    convenience init(
        urlRequest: URLRequestConvertible,
        completionHandler: ApiTaskHandler
    ) {
        self.init()
        self.urlRequest = urlRequest
        retrieveData(completionHandler)
    }

    init() {}

    public func retrieveData(completionHandler: ApiTaskHandler) {

        self.request = doRequest(self.urlRequest!, completionHandler: { (data) -> Void in
            completionHandler(data: data)
        })

    }

    public func start() -> ApiTask {
        guard let
            request = self.request
        else { return self }

        startNetworkActivity()
        request.resume()
        return self
    }

}

// MARK: ApiPresentable
extension ApiTask: ApiPresentable {

}

// MARK: Requestable
extension ApiTask: Requestable {

    public func requestDidFinishWithError(error: NSError) {
        requestDidFinishCommon()
        showError(error)
        self.taskFinished?()
        self.taskDidFinish?(task: self)
    }

    public func requestDidFinishWithNoNetworkConnection() {
        requestDidFinishCommon()
        showNoNetworkConnection()
        self.taskFinished?()
        self.taskDidFinish?(task: self)
    }

    public func requestDidFinish() {
        requestDidFinishCommon()
        self.taskFinished?()
        self.taskDidFinish?(task: self)
    }

    // MARK: private funcs

    private func requestDidFinishCommon() {
        stopNetworkActivity()
        showToast()
    }

}
