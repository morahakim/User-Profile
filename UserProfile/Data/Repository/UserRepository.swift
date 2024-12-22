//
//  UserRepository.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation
import Combine

public protocol UserRepository {
    func getUsers() -> AnyPublisher<[UserListResponse], Error>
    func getUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, any Error>
    func searchUsers(searchQuery: String) -> AnyPublisher<[UserListResponse], any Error>
}

public class UserRepositoryImpl: UserRepository {
    
    private let userDataSource: UserDataSource
    
    init(userDataSource: UserDataSource) {
        self.userDataSource = userDataSource
    }
    
    public func getUsers() -> AnyPublisher<[UserListResponse], any Error> {
        return userDataSource.fetchUsers()
                    .map { users in
                        users.map { $0.mapToModel() }
                    }
                    .mapError { $0 as Error } 
                    .eraseToAnyPublisher()
    }
    
    public func getUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, any Error> {
            return userDataSource.fetchUserDetail(userId: userId)
                .mapError { $0 as Error } 
                .eraseToAnyPublisher()
        }
    
    public func searchUsers(searchQuery: String) -> AnyPublisher<[UserListResponse], any Error> {
            return userDataSource.searchUsers(searchQuery: searchQuery)
                .map { users in
                    users.map { $0.mapToModel() }
                }
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
}
