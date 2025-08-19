//
//  BreedRow.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
import SwiftUI

struct BreedRow: View {
    
    var breed: Breed
    
    var body: some View {
        if breed.subbreeds.isEmpty {
            CustomisableNavigationLink{
                HStack(){
                    Text(breed.breedName.capitalized).padding()
                        .fontAppDefaultBold(size: 18)
                    Spacer()
                    Image(systemName: "camera")
                }
            } destination: {BreedDetailView(breed: SelectedBreed(breedName: breed.breedName, subbreed: nil))}
            
        }
        else {
            DisclosureGroup {
                ForEach(breed.subbreeds, id: \.self) {
                    subbreed in
                    CustomisableNavigationLink {
                        HStack {
                            Text(subbreed.capitalized)
                                .fontAppDefault(size: 18)
                                .padding()
                                .scaledToFill()
                            Spacer()
                            Image(systemName: "camera")
                            
                        }
                    } destination: {
                        BreedDetailView(breed: SelectedBreed(breedName: breed.breedName, subbreed: subbreed))
                    }
                    
                }
            } label: {
                Text(breed.breedName.capitalized).padding()
                    .fontAppDefaultBold(size: 18)
            }
        }
    }
}

#Preview {
    BreedRow(breed: Breed(breedName: "Hound", subbreeds: ["Afghan"]))
}


