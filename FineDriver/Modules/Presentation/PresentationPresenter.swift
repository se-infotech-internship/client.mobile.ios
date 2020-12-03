//
//  PresentationPresenter.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol PresentationViewProtocol: class {
    func configurePageView()
}

protocol PresentationPresenterProtocol {
    var viewControllers: [UIViewController] { get }

    func getViewControllers()
    func skip()
}

final class PresentationPresenter: NSObject, PresentationPresenterProtocol {
    
    var viewControllers: [UIViewController] = [UIViewController]()
    
    let titles = [
        "Заощаджуйте час та гроші:",
        "Додаток пряцює як в активному, так і в фоновому режимі: ",
        "Оплата штрафів в один клік:"
    ]
    
    let descs = [
        "Інформація про камери та сплата штрафів  в оному додатку.",
        "Коли на маршруті  з’явиться камера - миттєво прийде повідомлення про відстань до камери, напрямок її дії та ліміт швидкості.",
        "Оперативно отримуйте інформацію з державних реєстрів про наявність штрафів та миттєво сплачуйте їх прямо із додатку."
    ]
    
    let images = [
        "img_onboarding_1",
        "img_onboarding_2",
        "img_onboarding_3"
    ]
    
    weak var delegate: PresentationViewProtocol?
    
    init(delegate: PresentationViewProtocol) {
        self.delegate = delegate
    }
    
    func getViewControllers() {
        for index in 0...titles.count-1 {
            let vc =  AppCoordinator.shared.getPresentationContent(title: titles[index], desc: descs[index], image: images[index])
            viewControllers.append(vc)
        }
        delegate?.configurePageView()
    }
    
    func skip() {
        UserDefaults.standard.set(true, forKey: Constants.viewedPresentationScreen)
        UserDefaults.standard.synchronize()
        
        AppCoordinator.shared.routeToAuth()
    }
}
