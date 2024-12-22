//
//  UserListResponse.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation

public struct UserListResponse: Identifiable {
    public let id: Int
    public let fullName: String
    public let email: String
    public let thumbnailURL: String
}
