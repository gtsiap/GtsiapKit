//
//  JSONAPIManager.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 09/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import GtsiapKit
import Alamofire
import JSONAPIMapper

public class JSONAPIManager: ApiManager {

    public static let apiManager: JSONAPIManager = JSONAPIManager()

    private override init() {
        super.init()
        ApiManager.sharedManager = self
    }

    // MARK: tasks
    
    public func fetchResource<T: Mappable> (
        objectTask: ApiObjectTask<T>,
        includeRelationships: Bool = true
    ) -> ApiObjectTask<T> {
            
        var includeObjects = ""
        for (index, it) in T.relationships.keys.enumerate() {
            if index != 0 {
                includeObjects += ","
            }
            
            includeObjects += it
        }
            
        objectTask.urlRequest = createRequest(
            T.resource,
            parameters: [
                "include": includeObjects
            ],
            method: .GET
        )
        
        objectTask.taskResultProvider.objectTransformer =
        { (data: [String : AnyObject]) -> ([T]?) in
            do {
                return try Mapper<T>().fromJSON(data)
            } catch let error {
                print("Parsing Error: ")
                print(error)
                return nil
            }
        }
            
        return objectTask
            
    }
    
    private func createRequest(
        path: String,
        parameters: [String : String] = [String : String](),
        method: Alamofire.Method
    ) -> NSMutableURLRequest {

        let URL = NSURL(string: self.baseUrl)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue

        URLRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        URLRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")

        let email = self.userCredentials.email
        let password = self.userCredentials.password

        if !email.isEmpty && !password.isEmpty {
            let loginString = NSString(format: "%@:%@", email, password)
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = loginData.base64EncodedStringWithOptions([])

            URLRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }

        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
    }

}
