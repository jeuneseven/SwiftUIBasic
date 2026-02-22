//
//  Bundle+Decode.swift
//  SwiftUIBasic
//
//  Created by seven on 2026/2/23.
//

import Foundation

extension Bundle {
    // <T> is generics, <> also called Pulp Fiction brackets, T is stand for some type
    func decoder<T: Codable>(_ file: String) -> T {
        guard let loadFile = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to load file \(file)")
        }
        
        guard let data = try? Data(contentsOf: loadFile) else {
            fatalError("Failed to load data in file \(file)")
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
