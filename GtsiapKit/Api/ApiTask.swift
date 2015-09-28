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
    var request: Request?

    init() {
        self.networkIndicator = ActivityIndicatorView()
        self.showNetworkActivity = true
        self.toastView = ApiTask.createToast()
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
    }

    public func requestDidFinishWithNoNetworkConnection() {
        requestDidFinishCommon()
        showNoNetworkConnection()
    }

    public func requestDidFinish() {
        requestDidFinishCommon()
    }

    // MARK: private funcs

    private func requestDidFinishCommon() {
        stopNetworkActivity()
        showToast()
    }

}
