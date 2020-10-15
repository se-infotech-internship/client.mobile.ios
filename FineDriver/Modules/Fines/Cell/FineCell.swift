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
    
    // MARK: - Private outlets
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
    @IBOutlet private weak var hiddingView: UIView!
    
    // MARK: - Public properties
    static var identifier = "FineCell"
    var isHiddingContent: Bool? = true
    weak var delegate: FineCellDelegate?
    
    @IBAction private func didTapChangeSizeButton(_ sender: Any) {
        guard let isHiddingContent = isHiddingContent else { return }
        self.delegate?.changeSize(self, fineButtonTappedFor: isHiddingContent)
        self.isHiddingContent = !isHiddingContent
    }
    
    // MARK: - Public methods
    func changeSizeData(_ isHiddingContent: Bool) {
        if isHiddingContent {
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
                self.hiddingView.isHidden = true
                print("hide = \(self.contentView.frame.height)")
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi * 2) / 180.0)
                self.hiddingView.isHidden = false
                print("show = \(self.contentView.frame.height)")
            }
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
