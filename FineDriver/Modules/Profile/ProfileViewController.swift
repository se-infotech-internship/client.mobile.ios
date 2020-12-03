//
//  ProfileViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    // MARK:- Private outlets
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameInputView: InputView!
    @IBOutlet private weak var emailInputView: InputView!
    @IBOutlet private weak var phoneInputView: InputView!
    @IBOutlet private weak var passwordInputView: InputView!
    
    // MARK: - Public properties
    var presenter: ProfilePresenterProtocol!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        setupView()
        setupNavigationBar()
    }

    // MARK: - Private methods
    private func setupView() {
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        setViewData()
        presenter.fetchImage(imageView: avatarImageView)
    }
    
    private func setupNavigationBar() {
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "ПРОФIЛЬ")
    }
    
    fileprivate func setViewData() {
        emailInputView.text = presenter.profileData.email
        if let firstName = presenter.profileData.firstName,
           let lastName = presenter.profileData.lastName {
            nameInputView.text = "\(firstName) \(lastName)"
        }
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    
}
