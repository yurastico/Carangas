//
//  CarListingViewModel.swift
//  Carangas
//
//  Created by Yuri Cunha on 01/11/23.
//

import Foundation
import Observation


@Observable
final class CarListingViewModel {
    private(set) var cars: [Car] = []
    private let service = CarService()
    private(set) var state: LoadingState = .loading
    
    init() {
        
    }
    
    func loadCars(showingLoading: Bool = true) async {
        if showingLoading {
            state = .loaded
        }
        let result = await service.loadCars()
        switch result {
        case .success(let cars):
            self.cars = cars
        case .failure(let failure):
            print(failure)
        }
        state = .loaded
    }
    
    func deleteCar(with indexSet: IndexSet) async {
        guard let index = indexSet.first else { return }
        let car = cars[index]
        
        switch await service.deleteCar(car) {
        case .success:
            cars.remove(at: index)
        case .failure(let error):
            print(error)
        }
        
    }
    
}
