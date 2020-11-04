//
//  ProfilePresenter.swift
//  FineDriver
//
//  Created by Вячеслав on 18.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

protocol ProfileViewControllerProtocol: class {
    
}

protocol ProfilePresenterProtocol: class {
    var profileData: ProfileEntity { get }
    
    func viewDidLoad()
    func routePop()
    func fetchProfileData()
    func fetchImage(imageView: UIImageView)
}

final class ProfilePresenter {
    
    // MARK: - Protocol property
    weak var delegate: ProfileViewControllerProtocol?
    
    // MARK: - Private property
    private weak var coordinator = AppCoordinator.shared
    
    // MARK: - Public property
    private(set) var profileData = ProfileEntity()
    
    // MARK: - LifeCycle
    init(delegate: ProfileViewControllerProtocol?) {
        self.delegate = delegate
    }
}

// MARK: - Protocol methods
extension ProfilePresenter: ProfilePresenterProtocol {

    func viewDidLoad() {
        fetchProfileData()
    }
    
    func routePop() {
        coordinator?.popVC()
    }
    
    func fetchProfileData() {
        let defaults = UserDefaults.standard
        
        profileData.login = defaults[.user]
        profileData.email = defaults[.email]
        profileData.firstName = defaults[.firstName]
        profileData.lastName = defaults[.familyName]
    }
    
    func fetchImage(imageView: UIImageView) {
        
        var avatarURL: URL?
        avatarURL = UserDefaults.standard[.avatarURL]
        guard let url = avatarURL else { return }
        
        imageView.kf.setImage(with: url)
    }
}
