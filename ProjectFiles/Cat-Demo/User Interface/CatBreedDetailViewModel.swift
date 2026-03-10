//
//  CatBreedDetailViewModel.swift
//  Cat-Demo
//
//  Created by Banka Rajesh on 3/10/26.
//

import SwiftUI

@MainActor
class CatBreedDetailViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .loading
    
    private let breed: CatBreed
    
    init(breed: CatBreed) {
        self.breed = breed
    }
    
    func loadCatImage() {
        guard let breedId = breed.id else {
            loadingState = .failed
            return
        }
        
        loadingState = .loading
        
        Task {
            do {
                let image = try await fetchCatImage(breedId: breedId)
                loadingState = .loaded(image)
            } catch {
                loadingState = .failed
            }
        }
    }
    
    private func fetchCatImage(breedId: String) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            Network.fetchCatImage(breedId: breedId) { result in
                continuation.resume(with: result)
            }
        }
    }
}
