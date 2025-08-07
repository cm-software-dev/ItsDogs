//
//  BreedDetailView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI
import Combine

struct BreedDetailView: View {
    
    @ObservedObject var viewModel: BreedDetailViewModel
    
    var body: some View {
        List(){
            
        }
        
    }
}

#Preview {
    BreedDetailView(viewModel: BreedDetailViewModel(breed: "Dog", subbreed: "Sausage", api: DogAPI()))
}
