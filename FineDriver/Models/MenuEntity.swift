//
//  MenuModel.swift
//  FineDriver
//
//  Created by Вячеслав on 22.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation
import UIKit

final class MenuEntity {
    var avatar: UIImage
    
    init(avatar: UIImage) {
        self.avatar = avatar
    }
}

 final class MenuItemEntity {
    var iconItem: UIImage?
    var nameItem: String
    var notificationCount: Int?
    
    init(iconItem: UIImage?, nameItem: String, notificationCount: Int?) {
        self.iconItem = iconItem
        self.nameItem = nameItem
        self.notificationCount = notificationCount
    }
}

final class MenuNotificationEntity {
    var countNotification: Int
    
    init(countNotification: Int) {
        self.countNotification = countNotification
    }
}

// TODO: - Mock MenuScreen
func mockDataForMenuVC() -> [MenuItemEntity] {
    let map = MenuItemEntity(iconItem: UIImage(named: "map"),
                            nameItem: "Мапа",
                            notificationCount: nil)
    let fee = MenuItemEntity(iconItem: UIImage(named: "library_books"),
                            nameItem: "Штрафи",
                            notificationCount: 12)
    let camera = MenuItemEntity(iconItem: UIImage(named: "camera_alt"),
                                nameItem: "Перелік відеокамер",
                                notificationCount: nil)
    let profile = MenuItemEntity(iconItem: UIImage(named: "contact_page"),
                                nameItem: "Профіль користувача",
                                notificationCount: nil)
    let settings = MenuItemEntity(iconItem: UIImage(named: "settings"),
                                nameItem: "Налаштування додатку",
                                notificationCount: nil)
    let quastions = MenuItemEntity(iconItem: UIImage(named: "quastions"),
                                nameItem: "Популярні запитання",
                                notificationCount: nil)
    let presentation = MenuItemEntity(iconItem: UIImage(named: "presentation"),
                                nameItem: "Ознайомитись",
                                notificationCount: nil)
    let feedback = MenuItemEntity(iconItem: UIImage(named: "live_help"),
                                nameItem: "Зворотній зв’язок",
                                notificationCount: nil)
    let exit = MenuItemEntity(iconItem: UIImage(named: "meeting_room"),
                            nameItem: "Вихід",
                            notificationCount: nil)
    
    return [fee, camera, profile, settings, quastions, presentation, feedback, exit]
}

