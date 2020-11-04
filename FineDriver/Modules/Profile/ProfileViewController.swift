//
//  ProfileViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK:- Private outlets
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    
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
    
    private func setViewData() {
        loginLabel.text = presenter.profileData.login
        emailLabel.text = presenter.profileData.email
        fullNameLabel.text = "\(presenter.profileData.firstName ?? "") \(presenter.profileData.lastName ?? "")"
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    
}

// MARK: - NavigationBarDelegate method
extension ProfileViewController: NavigationBarDelegate {
    func leftAction() {
        presenter?.routePop()
    }
}
