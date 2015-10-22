//
//  FormDoubleTextFieldView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class FormDoubleTextFieldView: FormTextFieldView {

}

extension FormDoubleTextFieldView: FormTextFieldViewErrorable {
    public func hasError(string: String) -> (Bool, String) {

        if let _ = Double(string) {
            return (false, "")
        }

        return (true, "Only Numbers are allowed")
    }

}
