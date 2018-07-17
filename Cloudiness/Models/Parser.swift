//
//  Parser.swift
//  Cloudiness
//
//  Created by Admin on 7/14/18.
//  Copyright © 2018 Taras Melnyk. All rights reserved.
//

import SwiftyJSON

final class Parser {
    
    static func clouds() -> [Cloud] {
        var clouds = [Cloud]()
        guard let jsonString = WFileManager.fileContent() else {
            return clouds
        }
        let json = JSON(parseJSON: jsonString)
        let array = json.dictionary!["product"]!.dictionary!["time"]!.array!
        for entry in array {
            guard let cloudiness = entry.dictionary?["location"]?.dictionary?["cloudiness"]?.dictionary?["percent"]?.string else {
                continue
            }
            let from = entry.dictionary!["from"]!.string!
            let cloud = Cloud(from: from, cloudiness: cloudiness)
            clouds.append(cloud)
        }
        return clouds
    }
}
