//
//  CarListingView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

enum LoadingState {
    case loading
    case loaded
}

struct CarListingView: View {
    @State private var cars: [Car] = []
    @Binding var path: NavigationPath
    @State private var state: LoadingState = .loading
    private let service = CarService()
    var body: some View {
        Group {
            
            
            switch state {
            case .loaded:
                content
            case .loading:
                ZStack {
                    content
                        .opacity(0.5)
                    ProgressView(label: { Text("Loading...") })
                }
            }
        }
            .navigationTitle("Carros")
            .toolbar {
                Button("",systemImage: "plus") {
                    path.append(NavigationType.form(nil))
                }
            }
            .task {
                state = .loading
                await loadCars()
              
            }
    }
    
    var content: some View {
        List {
            ForEach(cars) { car in
                NavigationLink(value: NavigationType.detail(car)) {
                    HStack {
                        Text(car.name)
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                        
                        Spacer()
                        
                        Text(car.brand)
                            .foregroundStyle(.gray)
                    }
                }
                
            }
            .onDelete(perform: { indexSet in
                Task {
                    await deleteCar(with: indexSet)
                }
            })
        }
        .refreshable {
            await loadCars()
        }
    }
    
    
    private func loadCars() async {
        let result = await service.loadCars()
        switch result {
        case .success(let cars):
            self.cars = cars
        case .failure(let failure):
            print(failure)
        }
        state = .loaded
    }
    
    private func deleteCar(with indexSet: IndexSet) async {
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

#Preview {
    CarListingView(path: .constant(.init()))
}
