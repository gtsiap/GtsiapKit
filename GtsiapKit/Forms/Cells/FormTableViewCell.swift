
// Copyright (c) 2015 Giorgos Tsiapaliokas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
            self.formRow.formView as? FormView
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

            if let customHeight = formView.customHeightForForm {
                make.height.equalTo(customHeight)
                make.top.equalTo(self.contentView).priorityLow()
            } else {
                make.top.equalTo(self.contentView).offset(10)
            }

            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)


        }
    }

}
