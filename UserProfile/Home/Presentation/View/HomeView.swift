//
//  ContentView.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter<RunLoop>
    @State private var searchText: String = ""
    @State private var selectedUserId: SelectedUser? = nil
    @State private var detailPresenter: UserDetailPresenter<RunLoop>? = nil
    @State private var isDataLoaded: Bool = false

    
    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Users")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // Search Bar
            HStack {
                ZStack {
                    TextField("Search", text: $searchText)
                        .padding(.leading, 15)
                        .padding(.trailing, 40)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    HStack {
                        Spacer()
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                clearSearch()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 24)
                                        .shadow(radius: 1)
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
                    }
                }
                
                Spacer()
                
                // Search Button
                Button(action: {
                    presenter.searchUsers(query: searchText)
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(radius: 2)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Results Section
            if !presenter.searchResults.isEmpty {
                Text("SEARCH RESULTS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color.black, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                    )
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(presenter.searchResults) { user in
                            UserRowView(user: user, isSearchResult: true)
                                .padding(.horizontal)
                                .onTapGesture {
                                    prepareDetailPresenter(for: user.id)
                                }
                        }
                    }
                }
            }
            else {
                // Show "ALL USERS" only when no search results exist
                VStack(alignment: .leading) {
                    Text("ALL USERS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.black, lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                        )
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                    
                    if presenter.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(presenter.users) { user in
                                    UserRowView(user: user, isSearchResult: false)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            prepareDetailPresenter(for: user.id)
                                        }
                                        .opacity(isDataLoaded ? 1 : 0)
                                        .animation(.easeIn(duration: 0.3), value: isDataLoaded)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .sheet(item: $selectedUserId) { selectedUser in
            if isDataLoaded, let selectedUserId, let detailPresenter {
                DetailView(presenter: detailPresenter, userId: selectedUserId.id)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isDataLoaded)
                    .zIndex(1) 
            }
        }
        .onAppear {
            presenter.getUsers()
            withAnimation {
                isDataLoaded = true
            }
        }
        .background(Color.brown)
    }
    
    private func prepareDetailPresenter(for userId: Int) {
        selectedUserId = SelectedUser(id: userId)
        detailPresenter = UserDetailPresenter(
            scheduler: RunLoop.main,
            useCase: UserDetailInteractor(
                repository: UserRepositoryImpl(
                    userDataSource: UserDataSourceImpl()
                )
            )
        )
        withAnimation {
            isDataLoaded = true
        }
    }

    
    private func clearSearch() {
        searchText = ""
        presenter.clearSearchResults()
    }
}


struct SelectedUser: Identifiable {
    let id: Int
}

