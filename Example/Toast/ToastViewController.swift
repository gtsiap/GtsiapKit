//
//  ToastViewController.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/19/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import GtsiapKit

class ToastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showLongText(sender: AnyObject) {
       let longText =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean et maximus ante, at tincidunt lectus. Vestibulum " + "maximus, est nec aliquet efficitur, felis metus euismod lorem, ut iaculis erat erat tincidunt arcu. Mauris" + "tempus varius nisi a maximus. Quisque vitae velit sit amet ligula imperdiet consequat eget ut dui. Vivamus sed"
            "sapien non nibh aliquam vestibulum. Cras lacus nunc, pharetra eu urna a, efficitur convallis ante. Morbi a augue ac" +
            "dui porta semper. Nulla tempor dapibus nulla id efficitur. Morbi vitae tincidunt mauris, a fringilla felis. " +
            "Vestibulum semper sem sed neque consectetur, et fermentum leo condimentum. Sed ut mi eu ante porttitor fermentum." +
            "Sed mattis, ipsum suscipit pharetra lobortis, ex ligula tincidunt mi, sed dignissim justo nisi vel tellus."


        createToastView(longText)
    }

    @IBAction func showShortText(sender: AnyObject) {
        let shortText = "123"

        createToastView(shortText)
    }

    private func createToastView(text: String) {
        let toastView = ToastView()
        toastView.text = text
        toastView.superView = self.view
        toastView.toastDidHide = {
            println("Toast did hide")
        }
        toastView.showToast()
    }
}
