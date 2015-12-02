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

private struct RequestableDebugKey {
    static var debugKey = "requestable_debug_key"
}

// we want to use objc_getAssociatedObject/objc_setAssociatedObject
// so this one must be a class
enum RequestableDebugType {
    case JSONDeserializationError
    case NetworkError
    case NoInternetConnection
}

class RequestableDebug {
    let debugType: RequestableDebugType
    let debugHandler: () -> ()
    init(
        _ requestableDebugType: RequestableDebugType,
        debugHandler: () -> ()
    ) {
        self.debugType = requestableDebugType
        self.debugHandler = debugHandler
    }
}

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
        completionHandler: (data: [String : AnyObject]) -> ()
    ) -> Request {

        return request(urlRequest).response
        { (request, response, data, error) in

            func handleError(error: NSError) {
                self.requestDidFinishWithError(error)
            }
            
            func handleNoNetworkConnection() {
                // no internet connection
                    
                ApiManager.sharedManager.goOffline()
                    
                guard let
                    offlineDelegate = self.offlineDelegate,
                    request = request,
                    offlineData = offlineDelegate.retrieveRequest(request)
                else {
                    self.requestDidFinishWithNoNetworkConnection()
                    return
                }
                    
                completionHandler(data: offlineData)
                self.requestDidFinish()
            }
            
            networkLogger.debug("request: \(request)")
            networkLogger.debug("response: \(response)")
            networkLogger.debug("error: \(error)")
            
            if let debug = self.debug {
                switch debug.debugType {
                case .NoInternetConnection:
                    handleNoNetworkConnection()
                    debug.debugHandler()
                case .NetworkError:
                    handleError(NSError(
                        domain: "requestable.debug.networkError",
                        code: 1111,
                        userInfo: nil)
                    )
                    debug.debugHandler()
                case .JSONDeserializationError:
                    handleError(NSError(
                        domain: "requestable.debug.jsonError",
                        code: 2222,
                        userInfo: nil)
                    )
                    debug.debugHandler()
                }
                
                return
            }
            
            if let error = error where error.code == -1009 {
                handleNoNetworkConnection()
                return
            } else if let error = error {
                handleError(error)
                return
            }
            
            let jsonData: [String : AnyObject]?
            do {
                jsonData = try NSJSONSerialization.JSONObjectWithData(
                    data!,
                    options: NSJSONReadingOptions.AllowFragments
                ) as? [String : AnyObject]
                
                ApiManager.sharedManager.goOnline()
                networkLogger.debug("data: \(jsonData)")
                self.offlineDelegate?.storeRequest(request!, data: jsonData!)

                completionHandler(data: jsonData!)
                self.requestDidFinish()
            } catch let error as NSError {
                self.requestDidFinishWithError(error)
                return
            }
        }
    }
    
    var debug: RequestableDebug? {
        get {
            return objc_getAssociatedObject(
                self,
                &RequestableDebugKey.debugKey
            )as? RequestableDebug
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &RequestableDebugKey.debugKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        
    }

}
