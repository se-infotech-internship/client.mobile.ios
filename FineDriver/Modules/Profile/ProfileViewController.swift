//
//  ProfileViewController.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol ProfileViewControllerProtocol: class {
    
}

final class ProfileViewController: UIViewController {
    
    // MARK:- Private outlets
    @IBOutlet private weak var customNavigationBar: NavigationBar!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    
    // MARK: - Public properties
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupView()
        setupNavigationBar()
    }


    // MARK: - Private methods
    private func setupView() {
        avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        presenter?.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setViewData()
    }
    
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        customNavigationBar.delegate = self
        customNavigationBar.update(title: "ПРОФIЛЬ")
    }
    
    private func setViewData() {
        guard let presenter = presenter else { return }
        loginLabel.text = presenter.profileData.login
        emailLabel.text = presenter.profileData.email
        fullNameLabel.text = "\(presenter.profileData.firstName ?? "") \(presenter.profileData.lastName ?? "")"
    }
}

// MARK: - Protocol methods
extension ProfileViewController: ProfileViewControllerProtocol {
    
}

// MARK: - NavigationBarDelegate method
extension ProfileViewController: NavigationBarDelegate {
    
    func leftAction() {
        presenter?.routePop()
    }
}

// MARK: - Pop gesture delegate method
extension ProfileViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
