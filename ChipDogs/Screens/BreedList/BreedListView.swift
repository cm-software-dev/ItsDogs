//
//  BreedListView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI

struct BreedListView: View {
    
    @StateObject var viewModel: BreedListViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.breedList, id: \.breedName) {
                breed in
                BreedRow(breed: breed)
            }
        }
        .onAppear {
            viewModel.fetchBreeds()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
}

struct BreedRow: View {
    
    var breed: Breed
    
    var body: some View {
        if breed.subbreeds.isEmpty {
            NavigationLink(destination:
                            BreedDetailView(
                                viewModel: BreedDetailViewModel(breed: breed.breedName, api: DogAPI())),
                           label: {
                Text(breed.breedName.capitalized).padding()
            })
            
        }
        else {
            DisclosureGroup {
                ForEach(breed.subbreeds, id: \.self) {
                    subbreed in
                    NavigationLink(destination:
                                    BreedDetailView(
                                        viewModel: BreedDetailViewModel(
                                            breed: breed.breedName, subbreed: subbreed, api: DogAPI()
                                        )),
                                   label: {
                        Text(subbreed.capitalized).padding()
                    })
                }
            } label: {
                Text(breed.breedName.capitalized)
                    .padding()
            }
        }
    }
}

#Preview {
    BreedListView(viewModel: BreedListViewModel(dogAPI: DogAPI()))
}
