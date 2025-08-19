//
//  CustomisableNavigationLink.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
import SwiftUI

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

#Preview {
    CustomisableNavigationLink(label:{ Text("CustomNavLink")}, destination: {
        
    })
}
