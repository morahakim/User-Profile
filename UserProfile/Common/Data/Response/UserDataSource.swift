//
//  UserDataSource.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation
import Combine
import Alamofire

protocol UserDataSource {
    func fetchUsers() -> AnyPublisher<[User], AFError>
    func fetchUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, AFError>
    func searchUsers(searchQuery: String?) -> AnyPublisher<[User], AFError>
}

class UserDataSourceImpl: UserDataSource {
    let userEndpoint = "https://jsonplaceholder.typicode.com/users"
    
    func fetchUsers() -> AnyPublisher<[User], AFError> {
        return Future { promise in
            AF.request(self.userEndpoint)
                .validate()
                .responseDecodable(of: [User].self) { response in
                    switch response.result {
                    case .success(let users):
                        promise(.success(users))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, AFError> {
            let url = "\(userEndpoint)/\(userId)"
            
            return Future { promise in
                AF.request(url)
                    .validate()
                    .responseDecodable(of: User.self) { response in
                        switch response.result {
                        case .success(let user):
                            let userDetail = user.toDetailUser()
                            promise(.success(userDetail))
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    }
            }
            .eraseToAnyPublisher()
        }
    
    func searchUsers(searchQuery: String? = nil) -> AnyPublisher<[User], AFError> {
        return Future { promise in
            AF.request(self.userEndpoint)
                .validate()
                .responseDecodable(of: [User].self) { response in
                    switch response.result {
                    case .success(let users):
                        if let query = searchQuery, !query.isEmpty {
                            // Filter results based on name or email
                            let filteredUsers = users.filter { user in
                                user.name.lowercased().contains(query.lowercased()) ||
                                user.email.lowercased().contains(query.lowercased())
                            }
                            promise(.success(filteredUsers))
                        } else {
                            promise(.success(users))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

}
