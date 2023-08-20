//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/14/23.
//

import Foundation

extension String {
    func capitalizeWord() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
