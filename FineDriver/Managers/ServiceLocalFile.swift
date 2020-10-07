//
//  ServiceLocalFile.swift
//  FineDriver
//
//  Created by Вячеслав on 06.10.2020.
//  Copyright © 2020 Infotekh. All rights reserved.
//

import Foundation


final class ServiceLocalFile {
    
    func readLocalFile() -> Data? {
        
        do {
            if let bundle = Bundle.main.path(forResource: "cameras_list", ofType: "json"),
                let jsonData = try String(contentsOfFile: bundle).data(using: .utf8) {
                return jsonData
            }
        } catch {
            debugPrint(error)
        }
        return nil
    }
    
    func fetchLocationList(jsonData: Data, success: @escaping ([CameraModel]) -> Void, fail: @escaping (String) -> Void) {
        
        do {
            let decodedData = try JSONDecoder().decode([CameraModel].self, from: jsonData)
            success(decodedData)
            
        } catch let error {
            fail("parse \(error.localizedDescription)")
        }
    }
}
