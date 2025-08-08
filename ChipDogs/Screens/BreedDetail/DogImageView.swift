//
//  DogImageView.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 08/08/2025.
//

import SwiftUI

struct DogImageView: View
{
    let url: URL?
    private var isRetry: Bool = false
    
    init(url: URL?) {
        self.init(url: url, isRetry: false)
    }
    
    private init(url: URL?, isRetry: Bool) {
        self.url = url
        self.isRetry = isRetry
    }
    
    var body: some View {
        AsyncImage(url: url) {
            phase in
            switch phase {
            case .empty:
                ProgressView()
                    .controlSize(.large)
                    .frame(width: 300, height: 200)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(nil, contentMode: .fit)
            case .failure(let error):
                if !isRetry && (error as? URLError)?.code == .cancelled {
                    DogImageView(url: url, isRetry: true)
                } else {
                    EmptyView()
                }
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    DogImageView(url: URL(string:"https://images.dog.ceo/breeds/affenpinscher/n02110627_3144.jpg"))
}
