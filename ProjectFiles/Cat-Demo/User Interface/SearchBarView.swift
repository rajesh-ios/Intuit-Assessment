//
//  SearchBarView.swift
//  Cat-Demo
//
//  Created by Banka Rajesh on 3/10/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search breeds", text: $searchText)
        }
        .padding(.all, 8)
    }
}
