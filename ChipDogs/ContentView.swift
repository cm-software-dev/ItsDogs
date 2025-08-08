//
//  ContentView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        BreedListView(viewModel: BreedListViewModel(dogAPI: DogAPI()))
    }
}

#Preview {
    ContentView()
}
