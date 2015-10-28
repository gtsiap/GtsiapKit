// Copyright (c) 2015 Giorgos Tsiapaliokas
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

public protocol RequestableOfflineDelegate: class {

    func storeRequest(urlRequest: NSURLRequest, data: [String : AnyObject])
    func retrieveRequest(urlRequest: NSURLRequest) -> [String : AnyObject]?

}

public protocol Requestable: ApiPresentable {

    weak var offlineDelegate: RequestableOfflineDelegate? { get set }

    func requestDidFinishWithError(error: NSError)
    func requestDidFinishWithNoNetworkConnection()
    func requestDidFinish()
}

extension Requestable {

    func doRequest(
        urlRequest: URLRequestConvertible,
        completionHandler: (data: [String : AnyObject]) -> Void
    ) -> Request {

        return request(urlRequest).response {
                (request, response, data, error) in

                // in future versions check for errors
                networkLogger.debug("request: \(request)")
                networkLogger.debug("response: \(response)")
                networkLogger.debug("error: \(error)")

                var jsonError: NSError?
                let jsonData: [String : AnyObject]?
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(data!,
                        options: NSJSONReadingOptions.AllowFragments)
                    as? [String : AnyObject]
                } catch let error as NSError {
                    jsonError = error
                    jsonData = nil
                } catch {
                    fatalError()
                }

                networkLogger.debug("data: \(jsonData)")

                var networkError: NSError?

                // TODO
                if let error = error {

                    if error.code == -1009 {
                        // no internet connection is available
                        ApiManager.sharedManager.goOffline()

                        if let storedData: [String : AnyObject] = self.offlineDelegate?.retrieveRequest(request!) {
                            completionHandler(data: storedData)
                            self.requestDidFinish()

                            return
                        }

                        self.requestDidFinishWithNoNetworkConnection()
                        return
                    }

                    networkError = error

                } else if jsonError != nil {
                    networkError = jsonError
                }

                if error == nil {
                    ApiManager.sharedManager.goOnline()
                    self.offlineDelegate?.storeRequest(request!, data: jsonData!)
                    completionHandler(data: jsonData!)
                    self.requestDidFinish()
                } else {
                    self.requestDidFinishWithError(networkError!)
                }
            }
    }

}
