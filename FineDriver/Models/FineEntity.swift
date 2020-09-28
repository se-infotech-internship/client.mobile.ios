//
//  FineEntity.swift
//  FineDriver
//
//  Created by Вячеслав on 28.09.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation

final class FineEntity {
    var fineId: String
    var isPaidFine: Bool
    var articleNumber: String
    var articleText: String
    var date: String
    var carModel: String
    var carSign: String
    var countMoney: String
    var timeFine: String
    
    init(fineId: String,
         isPaidFine: Bool,
         articleNumber: String,
         articleText: String,
         date: String,
         carModel: String,
         carSign: String,
         countMoney: String,
         timeFine: String) {
        
        self.fineId = fineId
        self.isPaidFine = isPaidFine
        self.articleNumber = articleNumber
        self.articleText = articleText
        self.date = date
        self.carModel = carModel
        self.carSign = carSign
        self.countMoney = countMoney
        self.timeFine = timeFine
    }
}

// TODO: - Mock MenuScreen
func mockDataForFinesVC() -> [FineEntity] {
    let one = FineEntity(fineId: "ЕАВ/ 245686539", isPaidFine: true, articleNumber: "Ст. 122", articleText: "Перевищення встановлених обмежень руху, проїзд на забороненний сигнал регулювання ", date: "28.09.2020", carModel: "Moskvich 2141", carSign: "АА 2233 AЖ", countMoney: "475 грн.", timeFine: "12:34")
    let two = FineEntity(fineId: "ЕАВ/ 245686539", isPaidFine: false, articleNumber: "Ст. 122", articleText: "Перевищення встановлених обмежень руху, проїзд на забороненний сигнал регулювання ", date: "28.09.2020", carModel: "Moskvich 2141", carSign: "АА 2233 AЖ", countMoney: "475 грн.", timeFine: "12:34")
    let three = FineEntity(fineId: "ЕАВ/ 245686539", isPaidFine: true, articleNumber: "Ст. 122", articleText: "Перевищення встановлених обмежень руху, проїзд на забороненний сигнал регулювання ", date: "28.09.2020", carModel: "Moskvich 2141", carSign: "АА 2233 AЖ", countMoney: "475 грн.", timeFine: "12:34")
    let four = FineEntity(fineId: "ЕАВ/ 245686539", isPaidFine: false, articleNumber: "Ст. 122", articleText: "Перевищення встановлених обмежень руху, проїзд на забороненний сигнал регулювання ", date: "28.09.2020", carModel: "Moskvich 2141", carSign: "АА 2233 AЖ", countMoney: "475 грн.", timeFine: "12:34")
    
    return [one, two, three, four]
}
