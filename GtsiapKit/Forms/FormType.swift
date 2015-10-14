//
//  FormType.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 14/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public enum FormType {
    case Double(description: String)
    case ReadOnly(text: String, detailText: String?)
}
