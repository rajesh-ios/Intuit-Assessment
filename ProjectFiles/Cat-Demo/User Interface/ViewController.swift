// Copyright © 2021 Intuit, Inc. All rights reserved.
import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private var searchBarHostingController: UIHostingController<SearchBarView>?
    
    let viewModel = ViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel.catDataDelegate = self
        self.viewModel.getBreeds()
        
        setupSearchBar()
        observeSearchText()
    }
    
    private func observeSearchText() {
        viewModel.$searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupSearchBar() {

        let searchBarView = SearchBarView(
            searchText: Binding(
                get: { self.viewModel.searchText },
                set: { newValue in
                    self.viewModel.searchText = newValue
                }
            )
        )
        
        let hostingController = UIHostingController(rootView: searchBarView)
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        self.searchBarHostingController = hostingController
    }
}

// MARK: -
// MARK: TableView Delegate Methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catBreed", for: indexPath)
        
        cell.textLabel?.text = viewModel.filteredBreeds[indexPath.row].name
        cell.detailTextLabel?.text = viewModel.filteredBreeds[indexPath.row].description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let detailView = CatBreedDetailView(breed: viewModel.filteredBreeds[indexPath.row])
        
        let hostingController = UIHostingController(rootView: detailView)
        
        if let navController = navigationController {
            navController.pushViewController(hostingController, animated: true)
        }
    }
}

// MARK: -
// MARK: Cat Data Model Delegate Methods
extension ViewController: CatDataDelegate {
    func breedsChangedNotification() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
