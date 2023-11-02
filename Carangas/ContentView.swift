//
//  ContentView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            CarListingView(path: $path)
                .environment(CarListingViewModel())
                .navigationDestination(for: NavigationType.self) { type in
                    switch type {
                    case .detail(let car):
                        CarDetailView(path: $path)
                            .environment(CarDetailViewModel(car: car))
                    case .form(let car):
                        CarFormView(path: $path)
                            .environment(CarFormViewModel(car: car))
                    }
                }
        }
    }
}
