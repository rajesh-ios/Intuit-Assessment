// Copyright © 2021 Intuit, Inc. All rights reserved.
import Foundation
import Combine

/// Basic Delegate interface to send messages
protocol CatDataDelegate {
    func breedsChangedNotification()
}

/// View model
class ViewModel: ObservableObject {
    var catDataDelegate: CatDataDelegate?
    
    /// Array of all cat breeds
    @Published var catBreeds: [CatBreed] = [] {
        didSet {
            self.catDataDelegate?.breedsChangedNotification()
        }
    }
    
    @Published var searchText: String = ""
    
    /// Computed property that returns filtered breeds based on search text
    var filteredBreeds: [CatBreed] {
        if searchText.isEmpty {
            return catBreeds
        } else {
            return catBreeds.filter { breed in
                breed.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
    
    /// Get the breeds
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
