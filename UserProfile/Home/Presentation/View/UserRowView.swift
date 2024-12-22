//
//  UserRowView.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import SwiftUI

struct UserRowView: View {
    let user: UserListResponse
    let isSearchResult: Bool

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: user.thumbnailURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.black, lineWidth: 1)
                    )
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)
                Text("@\(user.email.split(separator: "@").first ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isSearchResult {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 2)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Image(systemName: "person.fill.badge.plus")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .background(Color.white.cornerRadius(10))
        )
    }
}
