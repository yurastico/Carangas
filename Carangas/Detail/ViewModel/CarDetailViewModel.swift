//
//  CarDetailViewModel.swift
//  Carangas
//
//  Created by Yuri Cunha on 01/11/23.
//

import Foundation
import Observation

@Observable
final class CarDetailViewModel {
    
    private(set) var car: Car
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }()
    
    init(car: Car) {
        self.car = car
    }
    
    var price: String {
        numberFormatter.string(from: NSNumber(value: car.price)) ?? "RS \(car.price)"
    }
    
    var brand: String {
        car.brand
    }
    var fuel: String {
        car.fuel
    }
    
    func refreshData() {
        self.car = car
    }
    
}
