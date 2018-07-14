//
//  WeatherFileManager.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

final class WeatherFileManager {
    private static let filename = "Weather.json"
    private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private static let fileURL = documentDirectory.appendingPathComponent(filename)
    
    public static func saveToFile(_ data: Data) {
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public static func fileContent() -> String? {
        do {
            let jsonString = try String(contentsOf: fileURL, encoding: .ascii)
            return jsonString
        } catch {
            return nil
        }
    }
}
