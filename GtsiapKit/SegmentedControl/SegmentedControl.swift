//
//  SegmentedControl.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 20/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import SnapKit

public class SegmentedControl: UIView {

    public var items: [AnyObject] = [AnyObject]() {
        didSet {
            createSegmentedControls()
        }
    }

    public var itemsPerRow = 3 {
        didSet {
            createSegmentedControls()
        }
    }

    public var spacing: Double = 0 {
        didSet {
            createSegmentedControls()
        }
    }

    public var value: String? {
        didSet {
            self.valueDidChange?(self.value)
        }
    }

    public var valueDidChange: ((String?) -> ())?

    private var segmentedControls: [UISegmentedControl] = [UISegmentedControl]()


    public init() {
        super.init(frame: CGRectZero)

        // HACK: workaround for iOS 9
        // If the keyboard is visible then the segmented control
        // won't call segmentedControlValueDidChange
        // on UIControl.valueChanged
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("keyboardWillAppear"),
            name: UIKeyboardWillShowNotification,
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("keyboardWillDisappear"),
            name: UIKeyboardWillHideNotification, object: nil
        )
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func createSegmentedControls() {
        removeSegmentedControlsFromView()

        var currentSegmentedControl = UISegmentedControl()
        addTargetForSegmentedControl(currentSegmentedControl)

        self.segmentedControls.append(currentSegmentedControl)
        for item in self.items {

            if !addSegment(currentSegmentedControl, item: item) {
                currentSegmentedControl = UISegmentedControl()

                addTargetForSegmentedControl(currentSegmentedControl)

                self.segmentedControls.append(currentSegmentedControl)
                currentSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
                addSegment(currentSegmentedControl, item: item)
            }
        }

        addSegmentedControlsToView()
    }

    private func addSegment(
        segmentedControl: UISegmentedControl,
        item: AnyObject
    ) -> Bool {
        guard
            segmentedControl.numberOfSegments < self.itemsPerRow
        else { return false }

        let segmentIndex = segmentedControl.numberOfSegments
        segmentedControl.insertSegmentWithTitle(
            item as? String,
            atIndex: segmentIndex,
            animated: false
        )

        return true
    }

    private func addSegmentedControlsToView() {
        var previousControl: UISegmentedControl!

        for (index, control) in self.segmentedControls.enumerate() {
            addSubview(control)

            if index == 0 {
                control.snp_makeConstraints() { make in
                    make.left.right.equalTo(self)
                    make.top.equalTo(self)
                }

            } else {
                control.snp_makeConstraints() { make in
                    make.left.right.equalTo(self)
                    make.top.equalTo(previousControl.snp_bottom)
                        .offset(self.spacing).priorityLow()
                }
            }

            previousControl = control
        }

        previousControl.snp_makeConstraints { make in
            make.bottom.equalTo(self)
        }
    }

    private func removeSegmentedControlsFromView() {
        for segment in self.segmentedControls {
            segment.removeFromSuperview()
        }

        self.segmentedControls.removeAll()
    }

    private func addTargetForSegmentedControl(segmentedControl: UISegmentedControl) {
        segmentedControl.addTarget(
            "self",
            action: Selector("segmentedControlValueDidChange:"),
            forControlEvents: .ValueChanged
        )
    }

    // MARK: actions
    @objc private func segmentedControlValueDidChange(sender: UISegmentedControl) {

        if let
            value = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        {
            self.value = value
        }

        for control in self.segmentedControls {
            guard control != sender else { continue }
            control.selectedSegmentIndex = -1
        }

    }

    @objc private func keyboardWillAppear() {
        self.userInteractionEnabled = false
    }

    @objc private func keyboardWillDisappear() {
        self.userInteractionEnabled = true
    }

}
