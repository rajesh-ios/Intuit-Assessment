//
//  LoadingState.swift
//  Cat-Demo
//
//  Created by Banka Rajesh on 3/10/26.
//

import SwiftUI

enum LoadingState {
    case loading
    case loaded(UIImage)
    case failed
}

struct CatBreedDetailView: View {
    let breed: CatBreed
    @StateObject private var viewModel: CatBreedDetailViewModel
    
    init(breed: CatBreed) {
        self.breed = breed
        _viewModel = StateObject(wrappedValue: CatBreedDetailViewModel(breed: breed))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                switch viewModel.loadingState {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                case .loaded(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                case .failed:
                    Image("dummy-image-square")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                }
                
                Text(breed.name ?? "Unknown Breed")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let description = breed.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Breed Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(description)
                            .font(.body)
                    }
                }
                
                if let temperament = breed.temperament {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Temperament")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(temperament)
                            .font(.body)
                    }
                }
                
                if let lifeSpan = breed.life_span {
                    HStack {
                        Text("Life Span of this Cat Breed is")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(lifeSpan)
                            .font(.body)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(breed.name ?? "Cat Breed")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadCatImage()
        }
    }
}

// MARK: - Preview


#Preview("Failed to load breed data") {
    NavigationView {
        CatBreedDetailView(breed: CatBreed(
            id: nil,
            name: "Abyssinian",
            description: "The Abyssinian is easy to care for, and a joy to have in your home. They're affectionate cats and love both people and other animals.",
            temperament: "Active, Energetic, Independent, Intelligent, Gentle",
            life_span: "14 - 15",
            wikipedia_url: "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
            experimental: 0,
            hairless: 0,
            indoor: 0,
            lap: nil,
            hypoallergenic: 0,
            rare: 0,
            natural: 1,
            adaptability: 5,
            affection_level: 5,
            child_friendly: 3,
            dog_friendly: 4,
            energy_level: 5,
            grooming: 1,
            health_issues: 2,
            intelligence: 5,
            shedding_level: 2,
            social_needs: 5,
            stranger_friendly: 5,
            vocalisation: 1,
            reference_image_id: nil,
            image: nil
        ))
    }
}

#Preview("Loaded breed data") {
    NavigationView {
        CatBreedDetailView(breed: CatBreed(
            id: "abys",
            name: "Abyssinian",
            description: "The Abyssinian is easy to care for, and a joy to have in your home. They're affectionate cats and love both people and other animals.",
            temperament: "Active, Energetic, Independent, Intelligent, Gentle",
            life_span: "14 - 15",
            wikipedia_url: "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
            experimental: 0,
            hairless: 0,
            indoor: 0,
            lap: nil,
            hypoallergenic: 0,
            rare: 0,
            natural: 1,
            adaptability: 5,
            affection_level: 5,
            child_friendly: 3,
            dog_friendly: 4,
            energy_level: 5,
            grooming: 1,
            health_issues: 2,
            intelligence: 5,
            shedding_level: 2,
            social_needs: 5,
            stranger_friendly: 5,
            vocalisation: 1,
            reference_image_id: nil,
            image: nil
        ))
    }
}
