//
//  HomeDashboardView.swift
//  Hinted
//
//  Created by esther ricardo on 10/17/26.
//
import SwiftUI

// MARK: - Home Dashboard

struct HomeDashboardView : View {
    
    @Binding var selectedTab: Int
    @Binding var showDashboard: Bool
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                // Welcome Message
                Text("Good morning, Esther")
                    .font(HintedFonts.adLib(30))
                    .foregroundStyle(.black)
                
                // Weather Section
                Text("Today's Weather")
                    .font(.headline)
                
                // Outfit Section
                Text("Today's Outfit")
                    .font(.headline)
                
                // Closet Section
                Text("My Closet")
                    .font(.headline)
                
                // MARK: - Temporary Return Button
                Button {
                    showDashboard = false
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back to Welcome")
                    }
                    .font(.subheadline)
                    .foregroundStyle(HintedColors.purple)
                }
            }
            .padding(20)
        }
        .background(HintedColors.cream)
    }
}

    #Preview {
        HomeDashboardView(
            selectedTab: .constant(0),
            showDashboard: .constant(true)
        )
}

