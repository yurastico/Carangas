//
//  CarFormView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

struct CarFormView: View {
    @Binding var car: Car?
    @Binding var path: NavigationPath
    @State private var brand = ""
    @State private var name = ""
    @State private var price: Int = 0
    @State private var gasType: Int = 0
    @State private var isSaving = false
    private let service = CarService()
    var isEditting: Bool {
        car != nil
    }
    
    
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
                    await save()
                }
               
            } label: {
                Text(isEditting ? "Alterar" : "Cadastrar")
                    .frame(maxWidth: .infinity)
            }
            .disabled(isSaving)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle(isEditting ? "Edicao" : "Cadastro")
        .onAppear {
            setupView()
        }
    }
    private func setupView() {
        name = car?.name ?? ""
        brand = car?.brand ?? ""
        price = car?.price ?? 0
        gasType = car?.gasType ?? 0
    }
    
    private func save() async {
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
        goBack()
       
    }
    
    private func goBack() {
        path.removeLast()
    }
}

#Preview {
    CarFormView(car: .constant(nil),path: .constant(.init()))
}
