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

import Locksmith

extension ApiManager {

    public func saveCredentials() {
        do {
            let userCredentials = self.userCredentials

            let data = [
                "email": userCredentials.email,
                "password": userCredentials.password
            ]

            try Locksmith.saveData(data, forUserAccount: userAccount())

        } catch let error {
            print(error)
            print("save failed")
        }
    }

    public func loadCredentials() -> Bool {
        func loadFailed() -> Bool {
            print("Load Failed")
            return false
        }
        guard let
            data = Locksmith.loadDataForUserAccount(userAccount())
        else { return loadFailed() }

        guard let email = data["email"] as? String else { return loadFailed() }
        guard let password = data["password"] as? String else { return loadFailed() }

        self.userCredentials.email = email
        self.userCredentials.password = password

        return true
    }

    public func logout() {
        self.userCredentials.email = ""
        self.userCredentials.password = ""
        do {
            try Locksmith.deleteDataForUserAccount(userAccount())
        } catch {}
    }

    private func userAccount() -> String {
        let execName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleExecutable") as! String
        return execName + "_" + ApiManager.sharedManager.baseUrl
    }
}

public struct UserCredentials {
    public var email: String
    public var password: String
}
