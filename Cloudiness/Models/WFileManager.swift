//
//  WFileManager.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import Foundation

final class WFileManager {
    private static let filename = "Weather.json"
    private static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private static let fileURL = documentDirectory.appendingPathComponent(filename)
    
    static func saveToFile(_ data: Data) {
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func fileContent() -> String? {
        do {
            let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
            return jsonString
        } catch {
            return nil
        }
    }
    
    static func plistDictionary(byFilename filename: String) -> [String: String]? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: path) as? [String: String] {
            return dictionary
        }
        return nil
    }
}
