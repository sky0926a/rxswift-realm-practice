//
//  PlaylistTableViewCell.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/8.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import UIKit
import SnapKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension PlaylistTableViewCell: ViewControllerFlowProtocol {
    func setupUI() {
        titleLabel.numberOfLines = 0
    }
    func setupLayout() {
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.lessThanOrEqualTo(contentView.snp.top).offset(10)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-10)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.height.greaterThanOrEqualTo(40).priority(999)
        }
    }
}
