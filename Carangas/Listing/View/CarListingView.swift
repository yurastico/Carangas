//
//  CarListingView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

struct CarListingView: View {
    @Binding var path: NavigationPath
    @Environment(CarListingViewModel.self) var viewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loaded:
                content
            case .loading:
                ZStack {
                    content
                        .opacity(viewModel.state == .loading ? 0.5 : 1)
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
                
                await
                viewModel.loadCars()
              
            }
    }
    
    var content: some View {
        List {
            ForEach(viewModel.cars) { car in
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
                    await viewModel.deleteCar(with: indexSet)
                }
            })
        }
        .refreshable {
            await viewModel.loadCars(showingLoading: false)
        }
    }
    
    
  
}

#Preview {
    CarListingView(path: .constant(.init()))
}
