//
//  BreedListView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI

struct BreedListView: View {
    
    @StateObject var viewModel: BreedListViewModel
   
    var destinationView: BreedDetailView?
    @State var selectedBreed: SelectedBreed?
    
    var body: some View {
        
        NavigationSplitView {
            NavigationStack {
                List(viewModel.breedList, id: \.self){
                    breed in
                    BreedRow(breed: breed, selectedBreed: $selectedBreed)
                }
            }
        }
        detail: {
            if let breed = selectedBreed {
                BreedDetailView(breed: breed)
            }
            else {
                Text("No selection")
            }
        }
        .onAppear {
            viewModel.fetchBreeds()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
}

#Preview {
    BreedListView(viewModel: BreedListViewModel(dogAPI: DogAPI()))
}
