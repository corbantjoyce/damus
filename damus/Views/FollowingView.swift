//
//  FollowingView.swift
//  damus
//
//  Created by William Casarin on 2022-05-16.
//

import SwiftUI

struct FollowUserView: View {
    let target: FollowTarget
    let damus_state: DamusState

    static let markdown = Markdown()

    var body: some View {
        HStack {
            UserViewRow(damus_state: damus_state, pubkey: target.pubkey)
                .onTapGesture {
                    damus_state.nav.push(route: Route.ProfileByKey(pubkey: target.pubkey))
                }
            
            FollowButtonView(target: target, follows_you: false, follow_state: damus_state.contacts.follow_state(target.pubkey))
        }
        Spacer()
    }
}

struct FollowersYouKnowView: View {
    let damus_state: DamusState
    let friended_followers: [String]
    @ObservedObject var followers: FollowersModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(friended_followers, id: \.self) { pk in
                    FollowUserView(target: .pubkey(pk), damus_state: damus_state)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(NSLocalizedString("Followers You Know", comment: "Navigation bar title for view that shows who is following a user."))
    }
}

struct FollowersView: View {
    let damus_state: DamusState
    @ObservedObject var followers: FollowersModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(followers.contacts ?? [], id: \.self) { pk in
                    FollowUserView(target: .pubkey(pk), damus_state: damus_state)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(NSLocalizedString("Followers", comment: "Navigation bar title for view that shows who is following a user."))
        .onAppear {
            followers.subscribe()
        }
        .onDisappear {
            followers.unsubscribe()
        }
    }
}

struct FollowingView: View {
    let damus_state: DamusState
    
    let following: FollowingModel

    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(following.contacts.reversed(), id: \.self) { pk in
                    FollowUserView(target: .pubkey(pk), damus_state: damus_state)
                }
            }
            .padding()
        }
        .onAppear {
            following.subscribe()
        }
        .onDisappear {
            following.unsubscribe()
        }
        .navigationBarTitle(NSLocalizedString("Following", comment: "Navigation bar title for view that shows who a user is following."))
    }
}

/*
struct FollowingView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingView(contact: <#NostrEvent#>, damus_state: <#DamusState#>)
    }
}
 */
