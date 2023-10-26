//
//  CarDetailView.swift
//  Carangas
//
//  Created by Yuri Cunha on 25/10/23.
//

import SwiftUI

struct CarDetailView: View {
    @Binding var car: Car
    @Binding var path: NavigationPath
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }()
    
    
    var body: some View {
        VStack(spacing: 24) {
            CarDataView(image: "car.fill", type: "marca", value: car.brand)
            CarDataView(image: "fuelpump.fill", type: "Combustivel", value: car.fuel)
            CarDataView(image: "dollarsign.circle.fill", type: "marca", value: numberFormatter.string(from: NSNumber(value: car.price)) ?? "RS \(car.price)")
            Spacer()
        }
        .padding()
        .navigationTitle(car.name)
        .toolbar {
            Button("Editar") {
                path.append(NavigationType.form(car))
            }
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


#Preview {
    CarDetailView(car: .constant(.init()),path: .constant(.init()))
    
}
