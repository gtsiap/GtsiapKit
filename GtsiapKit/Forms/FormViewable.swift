//
//  FormViewable.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import SnapKit
import TZStackView

public protocol FormViewable {
    var resultChanged: ((AnyObject?) -> ())? { get set}
    var required: Bool { get set }
}

public class FormStackView: TZStackView, FormViewable {

    public var resultChanged: ((AnyObject?) -> ())?
    public var required: Bool = false

}
