//
//  DetailView.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var presenter: UserDetailPresenter<RunLoop>
    let userId: Int
    @Environment(\.presentationMode) var presentationMode
    @State private var isDetailViewVisible: Bool = false

    var body: some View {
        ZStack {
            Color.brown.ignoresSafeArea()

            // Content
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 60)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black, lineWidth: 1)
                        )

                    HStack {
                        Spacer()
                        Text("Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            closeSheet()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 1)
                                    )

                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 0)

                if presenter.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let user = presenter.userDetail {
                    ScrollView {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.darkOfBrown)
                                    .frame(width: 220, height: 220)

                                AsyncImage(url: URL(string: user.largeAvatarURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                }
                            }
                            .padding(.top)

                            // User Full Name
                            Text(user.fullName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            // User Details Rectangle
                            VStack(alignment: .leading, spacing: 10) {
                                DetailRow(label: "USERNAME", value: user.fullName)
                                DetailRow(label: "EMAIL", value: user.email)
                                DetailRow(label: "ADDRESS", value: user.address)
                                DetailRow(label: "PHONE", value: user.phone)
                                DetailRow(label: "WEBSITE", value: user.website)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            )
                            .padding(.horizontal)
                        }
                    }
                } else if let errorMessage = presenter.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .onAppear {
            presenter.getUserDetail(userId: userId)
        }
    }

    private func closeSheet() {
        presentationMode.wrappedValue.dismiss()
        withAnimation {
                isDetailViewVisible = true
            }
    }
}

