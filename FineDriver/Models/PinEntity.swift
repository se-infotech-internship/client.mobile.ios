//
//  PinEntity.swift
//  FineDriver
//
//  Created by Вячеслав on 29.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

struct PinEntity {
    var isActive: Bool
    var long: Double
    var lat: Double
    var limitation: String
    var adress: String
    
}

func mockDataForMapVC() -> [PinEntity] {
    let chokolovka = PinEntity(isActive: true, long: 30.453733, lat: 50.430978, limitation: "80 км/г", adress: "Чоколовский бул., 24")
    let teligi = PinEntity(isActive: true, long: 30.4500733, lat: 50.479628, limitation: "50 км/г", adress: "ул. Елены Телиги, 37")
    let naberegnoeShosse = PinEntity(isActive: true, long: 30.5266383, lat: 50.456949, limitation: "80 км/г", adress: "Шоссе Набережное, 4")
    let drNarodov27 = PinEntity(isActive: true, long: 30.5430257, lat: 50.419107, limitation: "50 км/ч", adress: "бул. Дружбы Народов, 27")
    let drNarodov36 = PinEntity(isActive: true, long: 30.5463586, lat: 50.4199671, limitation: "50 км/ч", adress: "бул. Дружбы Народов, 36")
    
    return [chokolovka, teligi, naberegnoeShosse, drNarodov27, drNarodov36]
}
