//
//  UserDetailResponse.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation

public struct UserDetailResponse: Identifiable {
    public let id: Int
    public let fullName: String
    public let email: String
    public let address: String
    public let phone: String
    public let website: String
    public let companyName: String
    public let largeAvatarURL: String
}
