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

import GtsiapKit
import Alamofire
import JSONAPIMapper

public extension ApiManager {
    
    // MARK: tasks
    @available(*, deprecated=1.0, message="Use JSONApiTask")
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

        objectTask.urlRequest = fetchURLRequest(
            T.resource,
            parameters: [
                "include": includeObjects
            ]
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
    
    @available(*, deprecated=1.0, message="Use JSONApiTask")
    public func createResource<T: Mappable> (
        resourceObject: T,
        objectTask: ApiObjectTask<T>
    ) -> ApiObjectTask<T> {

        let body: String

        do {
            body = try Mapper<T>().createResourceJSON(resourceObject)
        } catch let error {
            print("Parsing Error: ")
            print(error)
            fatalError()
        }

        objectTask.urlRequest = createURLRequest(
            T.resource,
            body: body
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

    // MARK: private funcs

    private func fetchURLRequest(
        path: String,
        parameters: [String : String] = [String : String]()
    ) -> NSMutableURLRequest {

        let URL = NSURL(string: self.baseUrl)!
        let urlRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        urlRequest.HTTPMethod = Alamofire.Method.GET.rawValue

        addHeaders(urlRequest)
        addCredentials(urlRequest)

        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(urlRequest, parameters: parameters).0
    }

    private func createURLRequest(
        path: String,
        body: String
    ) -> NSMutableURLRequest {

        let URL = NSURL(string: self.baseUrl)!
        let urlRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        urlRequest.HTTPMethod = Alamofire.Method.POST.rawValue

        addHeaders(urlRequest)
        addCredentials(urlRequest)

        urlRequest.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)

        return urlRequest
    }

    // MARK: common private funcs

    private func addHeaders(urlRequest: NSMutableURLRequest) {
        urlRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/vnd.api+json", forHTTPHeaderField: "Content-Type")
    }

    private func addCredentials(urlRequest: NSMutableURLRequest) {

        let email = self.userCredentials.email
        let password = self.userCredentials.password

        if !email.isEmpty && !password.isEmpty {
            let loginString = NSString(format: "%@:%@", email, password)
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = loginData.base64EncodedStringWithOptions([])

            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        }
    }

}
