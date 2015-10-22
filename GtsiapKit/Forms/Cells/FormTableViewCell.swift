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

    private func configureCell() {
        guard let formView =
            self.formRow.formView as? UIView
        else { return }

        self.contentView.addSubview(formView)
        formView.translatesAutoresizingMaskIntoConstraints = false

        formView.snp_makeConstraints() { make in
            make.edges.equalTo(self.contentView)
        }

    }

}
