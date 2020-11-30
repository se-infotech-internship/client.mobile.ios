//
//  PresentationPresenter.swift
//  FineDriver
//
//  Created by Bohdan Turivniy on 30.11.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import UIKit

protocol PresentationPresenterProtocol {
    var viewControllers: [UIViewController] { get }

    func getViewControllers()
    func skip()
}

final class PresentationPresenter: NSObject, PresentationPresenterProtocol {
    
    var viewControllers: [UIViewController] = [UIViewController]()
    
    let titles = [
        "Tervetuloa apteekkiasiakkaiden Remomedi mobiilisovellukseen",
        "Pääsy verkkoon",
        "Turvallisuutesi - etusijamme"
    ]
    
    let descs = [
        "Remomedi-sovellus tarjoaa mahdollisuuden neuvotella apteekkihenkilökunnan kanssa ja ostaa apteekkitavaroita, myös lääkkeitä, verkossa. Katso käyttöopasta tai katso opasvideo",
        "Pääset tietyn apteekin apteekkiin mistä tahansa online-tilassa.",
        "Lääkevalmisteita koskevia neuvoja annetaan puhelun aikana, aivan kuten kun vierailet apteekissa henkilökohtaisesti."
    ]
    
    let images = [
        "img_onboarding_1",
        "img_onboarding_2",
        "img_onboarding_3"
    ]
    
    func getViewControllers() {
        for index in 0...titles.count-1 {
            let vc =  AppCoordinator.shared.getPresentationContent(title: titles[index], desc: descs[index], image: images[index])
            viewControllers.append(vc)
        }
    }
    
    func skip() {
        UserDefaults.standard.set(true, forKey: Constants.viewedPresentationScreen)
        UserDefaults.standard.synchronize()
        
        AppCoordinator.shared.routeToAuth()
    }
}
