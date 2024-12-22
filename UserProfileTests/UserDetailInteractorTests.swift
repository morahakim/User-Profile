//
//  UserDetailInteractorTests.swift
//  UserDetailInteractorTests
//
//  Created by mora hakim on 22/12/24.
//

import XCTest
import Combine
@testable import UserProfile

//MARK: Testing the UserDetailInteractor by simulating the repository using MockUserRepository
/*
 The tests cover:

 Whether the data received from the repository matches the mock (testGetUserDetail_Success).
 Whether errors are properly propagated from the repository (testGetUserDetail_Failure).
*/

final class UserDetailInteractorTests: XCTestCase {

    private var interactor: UserDetailInteractor!
    private var mockRepository: MockUserRepository!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepository = MockUserRepository()
        interactor = UserDetailInteractor(repository: mockRepository)
        cancellables = []
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockRepository = nil
        cancellables = nil
        try super.tearDownWithError()
    }

    func testGetUserDetail_Success() throws {
        // Arrange
        let mockUserDetail = UserDetailResponse(
            id: 1,
            fullName: "John Doe",
            email: "john.doe@example.com",
            address: "123 Main St",
            phone: "123-456-7890",
            website: "johndoe.com",
            companyName: "BSI",
            largeAvatarURL: "https://example.com/avatar.jpg"
        )
        mockRepository.mockResult = .success(mockUserDetail)

        // Act
        let expectation = XCTestExpectation(description: "User detail fetch successful")
        interactor.getUserDetail(userId: 1)
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Expected success, but got failure")
                }
            } receiveValue: { userDetail in
                // Assert
                XCTAssertEqual(userDetail.id, 1)
                XCTAssertEqual(userDetail.fullName, "John Doe")
                XCTAssertEqual(userDetail.email, "john.doe@example.com")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetUserDetail_Failure() throws {
        // Arrange
        let mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRepository.mockResult = .failure(mockError)

        // Act
        let expectation = XCTestExpectation(description: "User detail fetch failed")
        interactor.getUserDetail(userId: 1)
            .sink { completion in
                // Assert
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as NSError, mockError)
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testPerformanceExample() throws {
        self.measure {
            // Measure performance of fetching user detail
            interactor.getUserDetail(userId: 1)
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                .store(in: &cancellables)
        }
    }
}

// Mock User Repository
class MockUserRepository: UserRepository {
    func getUsers() -> AnyPublisher<[UserProfile.UserListResponse], any Error> {
        // Returns an empty array as the default
        return Just([])
            .setFailureType(to: (any Error).self)
            .eraseToAnyPublisher()
    }

    func searchUsers(searchQuery: String) -> AnyPublisher<[UserProfile.UserListResponse], any Error> {
        // Returns an empty array as the default
        return Just([])
            .setFailureType(to: (any Error).self)
            .eraseToAnyPublisher()
    }
    
    var mockResult: Result<UserDetailResponse, Error>!

    func getUserDetail(userId: Int) -> AnyPublisher<UserDetailResponse, any Error> {
        return Future { promise in
            if let result = self.mockResult {
                promise(result)
            } else {
                promise(.failure(NSError(domain: "MockUserRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mock result set"])))
            }
        }
        .eraseToAnyPublisher()
    }
}

