//
//  Workarounds.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 06/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public func _fix_unwind_in_pad_with_iOS8(segue: UIStoryboardSegue) {

    guard #available(iOS 9.0, *) else {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
        }

        return
    }

}
