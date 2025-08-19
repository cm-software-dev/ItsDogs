//
//  ContentView.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        BreedListView(viewModel:
                        BreedListViewModel(
                            imageService: DogImageService(api: APIManager.shared),
                            breedService: DogBreedService(api: APIManager.shared)))
    }
}

#Preview {
    ContentView()
}
