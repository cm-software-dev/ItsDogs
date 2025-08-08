//
//  BreedRow.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
import SwiftUI

struct BreedRow: View {
    
    var breed: Breed
    @Binding var selectedBreed: SelectedBreed?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if breed.subbreeds.isEmpty {
            if horizontalSizeClass == .regular
            {
                RowText(rowText: breed.breedName.capitalized)
                    .onTapGesture {
                        selectedBreed = SelectedBreed(breedName: breed.breedName, subbreed: nil)
                    }
            }
            else {
                NavigationLink(destination: BreedDetailView(breed: SelectedBreed(breedName: breed.breedName, subbreed: nil)), label: {
                    RowText(rowText: breed.breedName.capitalized)
                })
            }
        }
        else {
            DisclosureGroup {
                ForEach(breed.subbreeds, id: \.self) {
                    subbreed in
                    if horizontalSizeClass == .regular {
                        Text(subbreed.capitalized).padding().scaledToFill()
                            .onTapGesture {
                                selectedBreed = SelectedBreed(breedName: breed.breedName, subbreed: subbreed)
                            }
                    }
                    else {
                        NavigationLink(destination: BreedDetailView(breed: SelectedBreed(breedName: breed.breedName, subbreed: subbreed)), label: {
                            RowText(rowText: subbreed.capitalized)
                        })
                    }
                }
            } label: {
                RowText(rowText: breed.breedName.capitalized)
            }
        }
    }
}

struct RowText: View {
    
    let rowText: String
    
    var body: some View {
        Text(rowText).padding()
            .font(.headline)
    }
}

 #Preview {
     @Previewable @State var selectedBreed: SelectedBreed? = SelectedBreed(breedName: "Hound", subbreed: "Afghan")
     BreedRow(breed: Breed(breedName: "Hound", subbreeds: ["Afghan"]), selectedBreed: $selectedBreed)
 }
 
