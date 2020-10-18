//
//  SettingItemEntity.swift
//  FineDriver
//
//  Created by Вячеслав on 09.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

class SettingItemEntity {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}

final class SwitchItemEntity: SettingItemEntity {
    var isOn: Bool
    
    init(title: String, isOn: Bool) {
        self.isOn = isOn
        super.init(title: title)
    }
}

final class StepperEntity: SettingItemEntity {
    
    var distance: Int
    
    init(title: String, distance: Int) {
        self.distance = distance
        super.init(title: title)
    }
}



// TODO: - Mock SettingScreen
func mockDataForSettingVC() -> [SettingItemEntity] {
    let message = SettingItemEntity(title: "Повідомлення")
    let camera = SettingItemEntity(title: "Камери")
    let fine = SettingItemEntity(title: "Штрафи")
    let remind = SettingItemEntity(title: "Нагадування")
    let about = SettingItemEntity(title: "Про додаток")
    
    return [message, camera, fine, remind, about]
}

// TODO: - Mock MessageSettingScreen
func mockDataForMessageSettingVC() -> [SwitchItemEntity] {
    let mapMessage = SwitchItemEntity(title: "Повідомлення на мапі", isOn: false)
    let voiceMessage = SwitchItemEntity(title: "Голосові повідомлення", isOn: false)
    let soundMessage = SwitchItemEntity(title: "Звукові попередження", isOn: false)
    let pushMessage = SwitchItemEntity(title: "Push - повідомлення", isOn: false)
    
    return [mapMessage, voiceMessage, soundMessage, pushMessage]
}

func mockCameraSetting() -> [SettingItemEntity] {
    let one = SwitchItemEntity(title: "ВІДОБРАЖАТИ ВСІ КАМЕРИ", isOn: true)
    let two = SwitchItemEntity(title: "ВІДОБРАЖАТИ TRUCAM", isOn: true)
    let three = SwitchItemEntity(title: "ВІДОБРАЖАТИ КАМЕРИ ТІЛЬКИ ПО ОБРАНОМУ МАРШРУТУ", isOn: false)
    let four = StepperEntity(title: "РАДІУС ЗОНИ ПОПЕРЕДЖЕННЯ", distance: 700)
    
    return [one, two, three, four]
}
