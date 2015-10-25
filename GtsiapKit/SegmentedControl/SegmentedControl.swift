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

    private var kvoContext = UInt8()

    deinit {
        for control in self.segmentedControls {
            removeObserverForSegmentedControl(control)
        }
    }

    private func createSegmentedControls() {
        removeSegmentedControlsFromView()

        var currentSegmentedControl = UISegmentedControl()

        self.segmentedControls.append(currentSegmentedControl)
        for item in self.items {

            if !addSegment(currentSegmentedControl, item: item) {
                currentSegmentedControl = UISegmentedControl()

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

            addObserverForSegmentedControl(control)

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
            removeObserverForSegmentedControl(segment)
        }

        self.segmentedControls.removeAll()
    }

    // MARK: KVO
    public override func observeValueForKeyPath(
        keyPath: String?,
        ofObject object: AnyObject?,
        change: [String : AnyObject]?,
        context: UnsafeMutablePointer<Void>)
    {

        if keyPath != "selectedSegmentIndex" &&
            context != &self.kvoContext
        {
            return
        }

        guard let segmentedControl = object as? UISegmentedControl else { return }

        if let
            value = segmentedControl
                .titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)
        {
            self.value = value
        }

        for control in self.segmentedControls {
            guard control != segmentedControl else { continue }

            // If we don't remove the observer and call the selectedSegmentIndex
            // then the KVO will be triggered again. And then the selectedSegmentIndex
            // will call the KVO. In simple words we will trigger an infinite loop.
            // We can't use UIControlEvents.ValueChanged because
            // in iOS 9 if the keyboard is active the .ValueChanged target won't
            // be called.

            removeObserverForSegmentedControl(control)
            control.selectedSegmentIndex = -1
            addObserverForSegmentedControl(control)
        }

    }

    private func removeObserverForSegmentedControl(control: UISegmentedControl) {
        control.removeObserver(
            self,
            forKeyPath: "selectedSegmentIndex",
            context: &self.kvoContext
        )
    }

    private func addObserverForSegmentedControl(control: UISegmentedControl) {
        control.addObserver(
            self,
            forKeyPath: "selectedSegmentIndex",
            options: NSKeyValueObservingOptions.New,
            context: &self.kvoContext
        )
    }

}
