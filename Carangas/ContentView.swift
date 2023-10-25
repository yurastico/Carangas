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
            CarListingView()
                .navigationDestination(for: <#T##Hashable.Protocol#>) { type in
                    EmptyView()
                }
        }
    }
}

#Preview {
    ContentView()
}
