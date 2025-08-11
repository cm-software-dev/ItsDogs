//
//  BreedRow.swift
//  ChipDogs
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
                    RowText(rowText: breed.breedName.capitalized)
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
                RowText(rowText: breed.breedName.capitalized)
            }
        }
    }
}

struct RowText: View {
    
    let rowText: String
    
    var body: some View {
        Text(rowText).padding()
            .fontAppDefaultBold(size: 18)
    }
}

#Preview {
    BreedRow(breed: Breed(breedName: "Hound", subbreeds: ["Afghan"]))
}

struct CustomisableNavigationLink<Label: View, Destination: View>: View {
    let label: Label
    let destination: Destination
    
    init(@ViewBuilder label: () -> Label,
         @ViewBuilder destination: () -> Destination) {
        self.label = label()
        self.destination = destination()
    }
    
    var body: some View {
        // Hides default chevron accessory view for NavigationLink
        ZStack {
            NavigationLink {
                self.destination
            } label: {
                EmptyView()
            }
            .opacity(0)
            
            self.label
        }
    }
}
