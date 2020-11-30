//
//  ContentViewController.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class ContentViewController: BaseViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    var image: String?
    var caption: String?
    var desc: String?
    
    init(caption: String, desc: String, image: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.caption = caption
        self.desc = desc
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.caption = nil
        self.desc = nil
        self.image = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    fileprivate func configureUI() {
        titleLabel.text = caption
        descLabel.text = desc
        
        if let image = image {
            imgView.image = UIImage(named: image)
        }
    }

}
