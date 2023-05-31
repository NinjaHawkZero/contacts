//
//  EmailValidator.swift
//  Contacts
//
//  Created by Tom Phillips on 3/4/22.
//

import Foundation

struct EmailValidator {
    static func checkIfValid(email: String) -> Bool {
        let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue
        )
        
        let range = NSRange(
            email.startIndex..<email.endIndex,
            in: email
        )
        
        let matches = detector?.matches(
            in: email,
            options: [],
            range: range
        )
        
        // We only want our string to contain a single email
        // address, so if multiple matches were found, then
        // we fail our validation process and return nil:
        guard let match = matches?.first, matches?.count == 1 else {
            return false
        }
        
        print(match)
        
        // Verify that the found link points to an email address,
        // and that its range covers the whole input string:
        guard match.url?.scheme == "mailto", match.range == range else {
            return false
        }
        
        return true
    }
}


//Returns array of objects
///This class allows us to write/read any of our models to/from the app's documents directory.
final class DirectoryService {
    public static func readModelFromDisk<T: Decodable>() -> [T] {
        do {
            let directory = try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: false)
            let encodedModels = try Data(contentsOf: directory.appendingPathComponent("\(T.self).json"))
            let decodedModels = try JSONDecoder()
                .decode([T].self, from: encodedModels)
            return decodedModels
        } catch {
            debugPrint(error)
            return []
        }
    }
    
    //Pass in array of objects.
    public static func writeModelToDisk<T:Encodable>(_ models: [T]) {
        do {
            let directory = try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: false)
            try JSONEncoder()
                .encode(models)
                .write(to: directory.appendingPathComponent("\(T.self).json"))
        } catch {
            debugPrint(error)
        }
    }
}
