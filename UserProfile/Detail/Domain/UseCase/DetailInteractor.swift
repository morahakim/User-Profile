//
//  DetailInteractor.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation
import Combine

protocol UserDetailUseCase {
    func getUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, any Error>
}

class UserDetailInteractor: UserDetailUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func getUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, any Error> {
        return self.repository.getUserDetail(userId: userId)
    }
}
