//
//  ApiTask.swift
//
//  Created by Giorgos Tsiapaliokas on 7/18/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import Alamofire

public class ApiTask {

    public var viewController: UIViewController?
    public var toastView: ToastView
    public var showNetworkActivity: Bool
    public var networkIndicator: ActivityIndicatorView
    public var offlineDelegate: RequestableOfflineDelegate?
    var taskFinished: (() -> ())?

    var request: Request?

    init(
        urlRequest: URLRequestConvertible,
        completionHandler: (data: AnyObject?) -> ())
    {
        self.networkIndicator = ActivityIndicatorView()
        self.showNetworkActivity = true
        self.toastView = ApiTask.createToast()
        self.request = doRequest(urlRequest, completionHandler: completionHandler)
    }
}

// MARK: Taskable
extension ApiTask: Taskable {

    public func start() {
        startNetworkActivity()
        self.request?.resume()
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
    }

    public func requestDidFinishWithNoNetworkConnection() {
        requestDidFinishCommon()
        showNoNetworkConnection()
        self.taskFinished?()
    }

    public func requestDidFinish() {
        requestDidFinishCommon()
        self.taskFinished?()
    }

    // MARK: private funcs

    private func requestDidFinishCommon() {
        stopNetworkActivity()
        showToast()
    }

}
