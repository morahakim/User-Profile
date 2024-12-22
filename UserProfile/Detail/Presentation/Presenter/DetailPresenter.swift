//
//  DetailPresenter.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation
import Combine

class UserDetailPresenter<S: Scheduler>: ObservableObject {
    
    private var cancellable: Set<AnyCancellable> = []
    private let scheduler: S
    private let useCase: UserDetailUseCase
    
    @Published var userDetail: UserDetailResponse? = nil
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    init(scheduler: S, useCase: UserDetailUseCase) {
        self.scheduler = scheduler
        self.useCase = useCase
    }
    
    func getUserDetail(userId: Int) {
        self.isLoading = true
        self.errorMessage = nil
        
        self.useCase.getUserDetail(userId: userId)
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
            }, receiveValue: { userDetail in
                self.userDetail = userDetail
            })
            .store(in: &self.cancellable)
    }
}
