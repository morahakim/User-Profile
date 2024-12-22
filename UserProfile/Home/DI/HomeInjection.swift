//
//  Injection.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation

class HomeDependency {
    
    static let shared = HomeDependency()
    
    private init() {}
    
    private lazy var userDataSource: UserDataSource = UserDataSourceImpl()
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl(userDataSource: userDataSource)
    
    private lazy var homeUseCase: HomeUseCase = HomeInteractor(repository: userRepository)
    
    func makeHomePresenter() -> HomePresenter<RunLoop> {
        return HomePresenter(scheduler: RunLoop.main, useCase: homeUseCase)
    }
}
