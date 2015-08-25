//
//  SearchView.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 7/28/15.
//  Copyright (c) 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit

public class SearchView: UIView {

    // MARK: vars
    public var contentView: UIView? {
        didSet {
            if self.contentView == nil {
                return
            }

            oldValue?.removeFromSuperview()

            self.contentView!.translatesAutoresizingMaskIntoConstraints = false
            self.contentView!.backgroundColor =
                UIColor.UIColorFromRGB(
                    0xC9C9CE,
                    alpha: 1
                )
        }
    }

    public let searchBar: UISearchBar = UISearchBar()
    public var viewController: UIViewController?

    // MARK: closures

    public var didStartSearching: (() -> ())?
    public var didStopSearching: (() -> ())?

    // MARK: private vars
    private var searchBarBottomConstraint: NSLayoutConstraint!
    private var contentViewBarBottomConstraint: NSLayoutConstraint!

    // MARK: init

    public init() {
        super.init(frame: CGRectZero)

        initSearchBar()

        addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = constraint(self.searchBar, attribute1: .Width)
        let centerXConstraint = constraint(self.searchBar, attribute1: .CenterX)
        let topConstraint = constraint(self.searchBar, attribute1: .Top)

        self.searchBarBottomConstraint = constraint(self.searchBar, attribute1: .Bottom)

        addConstraints([widthConstraint, centerXConstraint, topConstraint, searchBarBottomConstraint])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func updateConstraints() {

        if self.contentViewBarBottomConstraint != nil {
            NSLayoutConstraint.deactivateConstraints([self.searchBarBottomConstraint])
            addConstraint(self.contentViewBarBottomConstraint)
        } else {
            NSLayoutConstraint.activateConstraints([self.searchBarBottomConstraint])
        }

        super.updateConstraints()
    }

    // MARK: private funcs

    private func initSearchBar() {
        self.searchBar.delegate = self
    }

    private func showContentView() {
        addSubview(self.contentView!)
        self.contentView!.hidden = false

        let widthConstraint = constraint(self.contentView!, attribute1: .Width)
        let centerXConstraint = constraint(self.contentView!, attribute1: .CenterX)

        let topConstraint = constraint(self.contentView!, attribute1: .Top, view2: self.searchBar, attribute2: .Bottom)
        self.contentViewBarBottomConstraint = constraint(self.contentView!, attribute1: .Bottom)

        addConstraints([widthConstraint, centerXConstraint, topConstraint])

        setNeedsUpdateConstraints()

        self.didStartSearching?()
    }

    private func hideContentView() {
        self.contentViewBarBottomConstraint = nil

        self.contentView?.removeFromSuperview()
        setNeedsUpdateConstraints()
    }

    private func showControls() {
        self.viewController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.searchBar.setShowsCancelButton(true, animated: true)
    }

    private func hideControls() {
        self.viewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: -
// MARK: UISearchBarDelegate

extension SearchView: UISearchBarDelegate {

    public func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.showContentView()
        self.showControls()
    }

    public func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.endEditing(true)

        hideControls()
        hideContentView()

        self.didStopSearching?()
    }
}
