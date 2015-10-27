//
//  FormViewable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import SnapKit
import TZStackView

public struct FormViewableError: ErrorType {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

public protocol FormViewable {
    var required: Bool { get set }
    func validate() throws
}

public class FormStackView: TZStackView, FormViewable {

    public var required: Bool = false

    public func validate() throws {
        for view in self.arrangedSubviews {
            guard let
                formViewable = view as? FormViewable
            else { continue }

            try formViewable.validate()
        }
    }

}
