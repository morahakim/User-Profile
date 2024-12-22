//
//  DetailInjection.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation

class DetailDependency {
    
    static let shared = DetailDependency()
    
    private lazy var userDataSource: UserDataSource = UserDataSourceImpl()
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl(userDataSource: userDataSource)
    
    private lazy var detailUseCase: UserDetailUseCase = UserDetailInteractor(repository: userRepository)
    
    func makeDetailPresenter() -> UserDetailPresenter<RunLoop> {
        return UserDetailPresenter(scheduler: RunLoop.main, useCase: detailUseCase)
    }
}
