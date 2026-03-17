// Copyright © 2021 Intuit, Inc. All rights reserved.
import Foundation
import Combine

@MainActor
final class ViewModel: ObservableObject {
    // MARK: - Inputs
    @Published var searchText: String = ""

    // MARK: - Outputs
    @Published private(set) var filteredBreeds: [CatBreed] = []

    // MARK: - Private state
    @Published private var catBreeds: [CatBreed] = []

    init() {
        
        Publishers.CombineLatest(
            $catBreeds,
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        )
        .map { breeds, searchText -> [CatBreed] in
            let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return breeds }
            let q = trimmed.lowercased()
            return breeds.filter { ($0.name ?? "").lowercased().contains(q) }
        }
        .removeDuplicates()
        .assign(to: &$filteredBreeds)
    }

    func breed(at index: Int) -> CatBreed {
        filteredBreeds[index]
    }

    func getBreeds() {
        Network.fetchCatBreeds { (result) in
            switch result
            {
            case .success(let breeds):
                self.catBreeds = breeds
            case .failure(let error):
                self.catBreeds = []
                print(error)
            }
        }
    }
}
