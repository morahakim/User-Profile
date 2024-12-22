//
//  UserDetailPresenterTests.swift
//  UserDetailPresenterTests
//
//  Created by mora hakim on 22/12/24.
//

import Testing
@testable import UserProfile
import Combine
import Foundation
import XCTest

//MARK: Testing the UserDetailPresenter which depends on UserDetailUseCase (in this case, using the mock implementation MockUserDetailUseCase).
/*
 The tests cover:

 Whether the presenter correctly updates its state (userDetail, isLoading, errorMessage) after receiving data (testFetchUserDetail_Success).
 Whether the presenter updates its state correctly in case of a failure (testFetchUserDetail_Failure).
 Testing behavior related to the view, such as processing raw data into a format usable by the UI.
*/

final class UserDetailPresenterTests: XCTestCase {
    var presenter: UserDetailPresenter<RunLoop>!
    var useCase: MockUserDetailUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        useCase = MockUserDetailUseCase()
        presenter = UserDetailPresenter(scheduler: RunLoop.main, useCase: useCase)
        cancellables = []
    }

    override func tearDown() {
        presenter = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchUserDetail_Success() {
        // Arrange
        let mockUser = UserDetailResponse(
            id: 1,
            fullName: "John Doe",
            email: "john.doe@example.com",
            address: "123 Main St",
            phone: "123-456-7890",
            website: "johndoe.com",
            companyName: "BSI",
            largeAvatarURL: "https://example.com/avatar.jpg"
        )
        useCase.mockResult = .success(mockUser)

        // Act
        let expectation = XCTestExpectation(description: "Fetch user details successfully")
        presenter.getUserDetail(userId: 1)

        presenter.$userDetail
            .dropFirst()
            .sink { userDetail in
                // Assert
                XCTAssertEqual(userDetail?.id, 1)
                XCTAssertEqual(userDetail?.fullName, "John Doe")
                XCTAssertEqual(userDetail?.email, "john.doe@example.com")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}

final class MockUserDetailUseCase: UserDetailUseCase {
    var mockResult: Result<UserDetailResponse, Error>?
    
    func getUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, Error> {
        if let mockResult = mockResult {
            switch mockResult {
            case .success(let user):
                return Just(user)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        } else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()
        }
    }
}
