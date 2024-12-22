//
//  ObjectMapper.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import Foundation

extension User {
    func mapToModel() -> UserListResponse {
        return UserListResponse(
            id: id,
            fullName: name,
            email: email,
            thumbnailURL: "https://i.pravatar.cc/150?img=\(id)"
        )
    }
    
    func toDetailUser() -> UserDetailResponse {
            return UserDetailResponse(
                id: id,
                fullName: name,
                email: email,
                address: "\(address.street), \(address.suite), \(address.city), \(address.zipcode)",
                phone: phone,
                website: website,
                companyName: company.name,
                largeAvatarURL: "https://i.pravatar.cc/300?img=\(id)"
            )
        }
}
