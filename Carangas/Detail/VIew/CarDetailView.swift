//
//  CarDetailView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

struct CarDetailView: View {
    @Binding var path: NavigationPath
    @Environment(CarDetailViewModel.self) var viewModel
    
    var body: some View {
        
        VStack(spacing: 24) {
            CarDataView(image: "car.fill", type: "marca", value: viewModel.brand)
            CarDataView(image: "fuelpump.fill", type: "Combustivel", value: viewModel.fuel)
            CarDataView(image: "dollarsign.circle.fill", type: "preco", value: viewModel.price)
            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.car.name)
        .toolbar {
            Button("Editar") {
                path.append(NavigationType.form(viewModel.car))
            }
        }
        .onAppear {
            viewModel.refreshData()
        }
    }
}

struct CarDataView: View {
    let image: String
    let type: String
    let value: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: image)
                Text(type)
            }
            
            Text(value)
                .fontWeight(.medium)
                .font(.title)
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity,alignment: .leading)
        }
        .padding()
        .background(.accent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}



