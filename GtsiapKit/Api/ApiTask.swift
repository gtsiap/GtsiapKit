//
//  ApiTask.swift
//
//  Created by Giorgos Tsiapaliokas on 7/18/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import Alamofire

public class ApiTask: Taskable {

    public typealias ApiTaskHandler = (data: [String : AnyObject]) -> ()

    public var viewController: UIViewController?
    public var toastView: ToastView
    public var showNetworkActivity: Bool
    public var networkIndicator: ActivityIndicatorView
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

    init() {
        self.networkIndicator = ActivityIndicatorView()
        self.showNetworkActivity = true
        self.toastView = ApiTask.createToast()
    }

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
