//
//  CarFormView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

struct CarFormView: View {
   
    @Binding var path: NavigationPath
    
    @State private var brand = ""
    @State private var name = ""
    @State private var price: Int = 0
    @State private var gasType: Int = 0

    @Environment(CarFormViewModel.self) var viewModel
    
    var body: some View {
        Form {
            Section("Dados do carro") {
                TextField("Marca",text: $brand)
                TextField("Name",text: $name)
            }
            
            Section("Preco") {
                TextField("Preco",value: $price,format: .number)
                    .keyboardType(.numberPad)
            }
            
            Section("Combustivel") {
                Picker("Preco",selection: $gasType) {
                    Text("Flex")
                        .tag(0)
                    Text("Alcool")
                        .tag(1)
                    Text("Gasolina")
                        .tag(2)
                }
                .pickerStyle(.segmented)
                    
            }
            
            Button {
                Task {
                    await viewModel.save(name: name, brand: brand, gasType: gasType, price: price)
                    goBack()
                }
               
            } label: {
                Text(viewModel.saveButtonTitle)
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.isSaving)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(viewModel.navigationTitle)
        .onAppear {
            setupView()
        }
    }
    private func setupView() {
        name = viewModel.name
        brand = viewModel.brand
        price = viewModel.price
        gasType = viewModel.gasType
    }
    
  
    
    private func goBack() {
        path.removeLast()
    }
}

