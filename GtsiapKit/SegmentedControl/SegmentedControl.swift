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

    public var itemsPerRow = 3
    public var spacing: Double = 0

    private var segmentedControls: [UISegmentedControl] = [UISegmentedControl]()

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
            addSubview(control)

            if index == 0 {
                control.snp_makeConstraints() { make in
                    make.top.left.right.equalTo(self)
                }
            } else {
                control.snp_makeConstraints() { make in
                    make.left.right.equalTo(self)
                    make.top.equalTo(previousControl.snp_bottom)
                        .offset(self.spacing)
                }
            }

            previousControl = control
        }

        addConstraints(constraints)
    }

    private func removeSegmentedControlsFromView() {
        for segment in self.segmentedControls {
            segment.removeFromSuperview()
        }
    }
}
