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
    public var taskDidFinish: ((task: ApiTask) -> ())?

    // Internal used for ApiGroup
    var taskFinished: (() -> ())?

    var request: Request?

    init(
        urlRequest: URLRequestConvertible,
        completionHandler: (data: [String : AnyObject]) -> ())
    {
        self.networkIndicator = ActivityIndicatorView()
        self.showNetworkActivity = true
        self.toastView = ApiTask.createToast()
        self.request = doRequest(urlRequest, completionHandler: completionHandler)
    }
}

// MARK: Taskable
extension ApiTask: Taskable {

    public func start() -> ApiTask {
        startNetworkActivity()
        self.request?.resume()
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
