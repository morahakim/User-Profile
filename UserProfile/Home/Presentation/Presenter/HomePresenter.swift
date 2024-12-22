//
//  HomePresenter.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation
import Combine

class HomePresenter<S: Scheduler>: ObservableObject {
    
    private var cancellable: Set<AnyCancellable> = []
    private let scheduler: S
    private let useCase: HomeUseCase
    
    @Published var users: [UserListResponse] = []
    @Published var searchResults: [UserListResponse] = []
    @Published var isLoading: Bool = true // Status loading
    @Published var errorMessage: String? = nil
    
    init(scheduler: S, useCase: HomeUseCase) {
        self.scheduler = scheduler
        self.useCase = useCase
    }
    
    func getUsers() {
        self.isLoading = true
        self.useCase.getUsers()
            .receive(on: self.scheduler)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error in Presenter: \(error)")
                }
            }, receiveValue: { users in
                self.users = users
            })
            .store(in: &self.cancellable)
    }
    
    func searchUsers(query: String) {
        self.isLoading = true
        self.useCase.searchUsers(searchQuery: query)
            .receive(on: self.scheduler)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error in Search: \(error)")
                }
            }, receiveValue: { users in
                self.searchResults = users
            })
            .store(in: &self.cancellable)
    }
    
    func clearSearchResults() {
        self.searchResults = []
    }
}

