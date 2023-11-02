//
//  Car.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import Foundation

// o 'final' nao deixa ninguem herdar dela, e ajuda na performance
final class Car: Codable,Identifiable {
    var _id: String?
    var brand: String
    var gasType: Int
    var name: String
    var price: Int
    
    lazy var id: String = UUID().uuidString // o lazy eh para o Codable nao utilizar essa propriedade
    
    
    var fuel: String {
        switch gasType {
        case 0:
            return "flex"
        case 1:
            return "Alcool"
        case 2:
            return "Gasolina"
        default:
            return "desconhecido"
        }
    }
    
    init(_id: String? = nil, brand: String = "", gasType: Int = 0, name: String = "", price: Int = 0) {
        self._id = _id
        self.brand = brand
        self.gasType = gasType
        self.name = name
        self.price = price
    }
}

extension Car: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Car: Equatable {
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs.id == rhs.id
    }
}
