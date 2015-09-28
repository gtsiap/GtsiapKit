//
//  Requestable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/23/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import Alamofire

public protocol RequestableOfflineDelegate: class {

    func storeRequest(urlRequest: NSURLRequest, data: AnyObject)
    func retrieveRequest(urlRequest: NSURLRequest) -> AnyObject?

}

public protocol Requestable: ApiPresentable {

    weak var offlineDelegate: RequestableOfflineDelegate? { get set }

    func requestDidFinishWithError(error: NSError)
    func requestDidFinishWithNoNetworkConnection()
    func requestDidFinish()

}

extension Requestable {
    public func doRequest(
        urlRequest: URLRequestConvertible,
        completionHandler: (data: AnyObject?) -> Void
    ) -> Request {

        return request(urlRequest).response {
                (request, response, data, error) in

                // in future versions check for errors
                networkLogger.debug("request: \(request)")
                networkLogger.debug("response: \(response)")
                networkLogger.debug("error: \(error)")

                var jsonError: NSError?
                let jsonData: AnyObject?
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(data!,
                        options: NSJSONReadingOptions.AllowFragments)
                } catch let error as NSError {
                    jsonError = error
                    jsonData = nil
                } catch {
                    fatalError()
                }

                networkLogger.debug("data: \(jsonData)")

                var networkError: NSError?

                // TODO
                if let error = error as? NSError {

                    if error.code == -1009 {
                        // no internet connection is available
                        ApiManager.sharedManager.goOffline()

                        if let storedData: AnyObject = self.offlineDelegate?.retrieveRequest(request!) {
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
                    completionHandler(data: jsonData)
                    self.requestDidFinish()
                } else {
                    self.requestDidFinishWithError(networkError!)
                }
            }
    }

}
