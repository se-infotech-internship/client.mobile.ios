//
//  FineCell.swift
//  FineDriver
//
//  Created by Вячеслав on 28.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol FineCellDelegate: class {
    func changeSize(_ cell: FineCell, fineButtonTappedFor fine: Bool)
}

final class FineCell: UITableViewCell {
    
    private enum Priority {
        static let big: Float = 1000
        static let low: Float = 700
    }
    
    // MARK: - Private outlets
    @IBOutlet private weak var zeroContentConstraint: NSLayoutConstraint!
    @IBOutlet private weak var showContentConstraint: NSLayoutConstraint!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var fineIdLabel: UILabel!
    @IBOutlet private weak var paidLabel: UILabel!
    @IBOutlet private weak var articleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var carModelLabel: UILabel!
    @IBOutlet private weak var carSignLabel: UILabel!
    @IBOutlet private weak var paidFineLabel: UILabel!
    @IBOutlet private weak var sumFineLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: - Public properties
    static var identifier = "FineCell"
    var isLowSize: Bool? = false
    weak var delegate: FineCellDelegate?

    @IBAction private func didTapChangeSizeButton(_ sender: Any) {
        guard let isLowSize = isLowSize else { return }
        self.delegate?.changeSize(self, fineButtonTappedFor: isLowSize)
        self.isLowSize = !isLowSize
    }
    
    // MARK: - Public methods
    func changeSizeData(_ lowSize: Bool) {
        if lowSize {
            UIView.animate(withDuration: 1) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
                self.zeroContentConstraint.priority = UILayoutPriority(rawValue: Priority.low)
                self.showContentConstraint.priority = UILayoutPriority(rawValue: Priority.big)
            }
        } else {
//            UIView.animate(withDuration: 1) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi * 2) / 180.0)
                self.zeroContentConstraint.priority = UILayoutPriority(rawValue: Priority.big)
                self.showContentConstraint.priority = UILayoutPriority(rawValue: Priority.low)
//            }
        }
    }
    
    func update(entity: FineEntity) {
        fineIdLabel.text = entity.fineId
        articleLabel.text = entity.articleNumber
        descriptionLabel.text = entity.articleText
        dateLabel.text = entity.date
        carModelLabel.text = entity.carModel
        carSignLabel.text = entity.carSign
        sumFineLabel.text = entity.countMoney
        
        if entity.isPaidFine {
            paidLabel.text = "Cплачено"
            paidLabel.textColor = UIColor(named: "Paid")
            paidFineLabel.text = "Сума штрафу"
            sumFineLabel.textColor = UIColor(named: "Paid")
        } else {
            paidLabel.text = "Hе сплачено"
            paidLabel.textColor = UIColor(named: "Ellipse31")
            paidFineLabel.text = "Cплатити штраф"
            sumFineLabel.textColor = UIColor(named: "Ellipse31")
        }
    }
}
