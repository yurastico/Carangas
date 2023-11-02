//
//  CarFormViewMoel.swift
//  Carangas
//
//  Created by Yuri Cunha on 01/11/23.
//

import Foundation
import Observation

@Observable
final class CarFormViewModel {
    private(set) var car: Car?
    private let service = CarService()
    private(set) var isSaving = false
    
    init(car: Car? = nil) {
        self.car = car
    }
    
    var isEditting: Bool {
        car != nil
    }
    
    var saveButtonTitle: String {
        isEditting ? "Alterar" : "Cadastrar"
    }
    var navigationTitle: String {
        isEditting ? "Edicao" : "Cadastro"
    }
    
    var brand: String {
        car?.brand ?? ""
    }
    var name: String {
        car?.name ?? ""
    }
    var price: Int {
        car?.price ?? 0
    }
    var gasType: Int {
        car?.gasType ?? 0
    }
    
    
    func save(name: String,brand: String,gasType: Int,price: Int) async {
        isSaving = true
        let finalCar = car ?? Car()
        finalCar.brand = brand
        finalCar.name = name
        finalCar.gasType = gasType
        finalCar.price = price
        
        if isEditting {
            await service.updateCar(finalCar)
        } else {
            await service.createCar(finalCar)
        }
        
       
    }
}
