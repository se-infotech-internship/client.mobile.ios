//
//  PinEntity.swift
//  FineDriver
//
//  Created by Вячеслав on 29.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

final class PinEntity {
    var isActive: Bool
    var long: Double
    var lat: Double
    var limitation: String
    let adress: String
    
    init(isActive: Bool, lat: Double, long: Double, limitation: String, adress: String) {
        self.isActive = isActive
        self.lat = lat
        self.long = long
        self.limitation = limitation
        self.adress = adress
    }
}

func mockDataForMapVC() -> [PinEntity] {
    let chokolovka = PinEntity(isActive: true, lat: 50.430978, long: 30.453733, limitation: "80 км/г", adress: "Чоколовский бул., 24")
    let teligi = PinEntity(isActive: true, lat: 50.479628, long: 30.4500733, limitation: "50 км/г", adress: "ул. Елены Телиги, 37")
    let naberegnoeShosse = PinEntity(isActive: true, lat: 50.456949, long: 30.5266383, limitation: "80 км/г", adress: "Шоссе Набережное, 4")
    let drNarodov27 = PinEntity(isActive: true, lat: 50.419107, long: 30.5430257, limitation: "50 км/ч", adress: "бул. Дружбы Народов, 27")
    let drNarodov36 = PinEntity(isActive: true, lat: 50.4199671, long: 30.5463586, limitation: "50 км/ч", adress: "бул. Дружбы Народов, 36")
    
    return [chokolovka, teligi, naberegnoeShosse, drNarodov27, drNarodov36]
}
