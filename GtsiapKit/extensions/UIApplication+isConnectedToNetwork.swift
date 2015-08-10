//
//  UIApplication+isConnectedToNetwork.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/10/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

extension UIApplication {

    public class func isConnectedToNetwork() -> Bool{

        var status: Bool = false
        let url = NSURL(string: "http://google.com/")

        let request = NSMutableURLRequest(URL: url!)

        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 4

        var response: NSURLResponse?

        var data = NSURLConnection.sendSynchronousRequest(
            request, returningResponse: &response, error: nil) as NSData?

        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }

        return status
    }

}
