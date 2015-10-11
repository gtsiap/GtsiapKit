//
//  Credentiable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/28/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

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
