//
//  MenuCell.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class MenuCell: UITableViewCell {
    
    // MARK: - Private outlets
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var notificationView: UIView!
    @IBOutlet private weak var countCallLabel: UILabel!
    @IBOutlet private weak var redRoundView: UIView!
    @IBOutlet private weak var yellowRoundView: UIView!
    
    // MARK: - Static property
    static let identifier = "MenuCell"
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Private methods
    private func setupView() {
        redRoundView.layer.cornerRadius = self.redRoundView.frame.size.width / 2
        redRoundView.clipsToBounds = true
    }

    private func setupNotificationView(count: Int?) {
        if count == nil {
            notificationView.isHidden = true
        } else {
            notificationView.isHidden = false
        }
    }
    
    // MARK: - Public method
    func update(model: MenuItemEntity) {
        iconImageView.image = model.iconItem
        nameLabel.text = model.nameItem
        setupNotificationView(count: model.notificationCount)
        countCallLabel.text = "\(model.notificationCount ?? 0)"
    }
}
