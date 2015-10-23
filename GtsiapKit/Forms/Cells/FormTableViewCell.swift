//
//  FormTableViewCell.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 22/10/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import UIKit
import SnapKit

class FormTableViewCell: UITableViewCell {

    var formRow: FormRow! {
        didSet {
            configureCell()
        }
    }

    private var cellView: UIView!

    private func configureCell() {
        guard let formView =
            self.formRow.formView as? UIView
        else { return }

        if let _ = self.cellView {
            // configureCell has been called from
            // UITableView.dequeueReusableCellWithIdentifier
            // for the second time. We have already configured
            // the view and we don't want to add the view again.
            // Q: When does this happen?
            // A: If you scroll in the tableview then
            //    the second time the tableview will reuse
            //    the cell, thats why we use it after all :)
            self.cellView.removeFromSuperview()
        }

        self.cellView = formView

        self.contentView.addSubview(self.cellView)
        self.cellView.translatesAutoresizingMaskIntoConstraints = false

        self.cellView.snp_makeConstraints() { make in
            make.top.left.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.right.equalTo(self.contentView).offset(-20)
        }
    }

}
