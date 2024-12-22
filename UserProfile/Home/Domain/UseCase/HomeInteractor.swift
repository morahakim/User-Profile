//
//  Interactor.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation
import Combine

protocol HomeUseCase {
    func getUsers() -> AnyPublisher<[UserListResponse], any Error>
    func searchUsers(searchQuery: String) -> AnyPublisher<[UserListResponse], any Error>
}

class HomeInteractor: HomeUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getUsers() -> AnyPublisher<[UserListResponse], any Error> {
        return self.repository.getUsers()
    }
    
    func searchUsers(searchQuery: String) -> AnyPublisher<[UserListResponse], any Error> {
        return self.repository.searchUsers(searchQuery: searchQuery)
    }
}
