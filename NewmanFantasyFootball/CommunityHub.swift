import SwiftUI

// MARK: - Community Feed View

struct CommunityFeedView: View {
    @EnvironmentObject var socialManager: SocialManager
    @State private var selectedFilter: FeedFilter = .all
    @State private var showingCreatePost = false
    @State private var showingNotifications = false

    enum FeedFilter: String, CaseIterable {
        case all = "All"
        case following = "Following"
        case achievements = "Achievements"
        case tips = "Tips"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(FeedFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.rawValue,
                                isSelected: selectedFilter == filter
                            ) {
                                selectedFilter = filter
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground))

                // Posts Feed
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredPosts) { post in
                            PostCard(post: post)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Community")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 16) {
                        NavigationLink(destination: LeaguesHubView()) {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(AppColors.billsBlue)
                        }

                        NavigationLink(destination: GroupsHubView()) {
                            Image(systemName: "person.3.fill")
                                .foregroundColor(AppColors.billsBlue)
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { showingNotifications = true }) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(AppColors.billsBlue)

                                if socialManager.unreadNotificationCount > 0 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 18, height: 18)
                                        .overlay(
                                            Text("\(socialManager.unreadNotificationCount)")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .offset(x: 8, y: -8)
                                }
                            }
                        }

                        Button(action: { showingCreatePost = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(AppColors.billsBlue)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreatePost) {
                CreatePostView()
            }
            .sheet(isPresented: $showingNotifications) {
                NotificationsView()
            }
        }
    }

    var filteredPosts: [SocialPost] {
        switch selectedFilter {
        case .all:
            return socialManager.posts
        case .following:
            return socialManager.posts // TODO: Filter by followed users
        case .achievements:
            return socialManager.posts.filter { $0.postType == .achievement }
        case .tips:
            return socialManager.posts.filter { $0.postType == .tip }
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(isSelected ? .white : AppColors.billsBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.billsBlue : Color(.systemGray6))
                .cornerRadius(20)
        }
    }
}

struct PostCard: View {
    @EnvironmentObject var socialManager: SocialManager
    let post: SocialPost
    @State private var showingComments = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Post Header
            HStack(spacing: 12) {
                Text(post.authorAvatar)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.authorName)
                        .font(AppFonts.body())
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    HStack {
                        Text(post.postType.rawValue)
                            .font(AppFonts.caption())
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(post.postType.color)
                            .cornerRadius(4)

                        Text(timeAgoString(from: post.timestamp))
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }

            // Post Content
            Text(post.content)
                .font(AppFonts.body())
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            // Engagement Bar
            HStack(spacing: 24) {
                Button(action: {
                    socialManager.toggleLike(post: post)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(post.isLiked ? .pink : .secondary)
                        Text("\(post.likeCount)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Button(action: { showingComments = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                            .foregroundColor(.secondary)
                        Text("\(post.commentCount)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Button(action: {
                    socialManager.sharePost(post)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.turn.up.right")
                            .foregroundColor(.secondary)
                        Text("\(post.shareCount)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
        .sheet(isPresented: $showingComments) {
            PostCommentsView(post: post)
        }
    }

    func timeAgoString(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 { return "Just now" }
        if seconds < 3600 { return "\(seconds / 60)m ago" }
        if seconds < 86400 { return "\(seconds / 3600)h ago" }
        return "\(seconds / 86400)d ago"
    }
}

// MARK: - Create Post View

struct CreatePostView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var socialManager: SocialManager
    @Environment(\.dismiss) var dismiss

    @State private var selectedPostType: SocialPost.PostType = .update
    @State private var postContent = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Post Type Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Post Type")
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SocialPost.PostType.allCases, id: \.self) { type in
                                PostTypeButton(type: type, isSelected: selectedPostType == type) {
                                    selectedPostType = type
                                }
                            }
                        }
                    }
                }
                .padding()

                // Content Input
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's on your mind?")
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    TextEditor(text: $postContent)
                        .frame(minHeight: 150)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Create Post")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Post") {
                    let newPost = SocialPost(
                        authorID: UUID(),
                        authorName: gameManager.teamName,
                        authorAvatar: gameManager.teamAvatar,
                        postType: selectedPostType,
                        content: postContent
                    )
                    socialManager.createPost(newPost)
                    dismiss()
                }
                .disabled(postContent.isEmpty)
                .foregroundColor(postContent.isEmpty ? .gray : AppColors.billsBlue)
            )
        }
    }
}

struct PostTypeButton: View {
    let type: SocialPost.PostType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .white : type.color)

                Text(type.rawValue)
                    .font(AppFonts.caption())
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? type.color : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Post Comments View

struct PostCommentsView: View {
    @EnvironmentObject var socialManager: SocialManager
    let post: SocialPost
    @State private var newComment = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Original Post
                ScrollView {
                    PostCard(post: post)
                        .padding()

                    Divider()

                    // Comments would go here
                    Text("Comments coming soon!")
                        .foregroundColor(.secondary)
                        .padding()
                }

                // Comment Input
                HStack {
                    TextField("Add a comment...", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        socialManager.addComment(to: post, content: newComment)
                        newComment = ""
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(AppColors.billsBlue)
                            .font(.system(size: 28))
                    }
                    .disabled(newComment.isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Leagues Hub View

struct LeaguesHubView: View {
    @EnvironmentObject var socialManager: SocialManager
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Tab Selector
            Picker("Leagues", selection: $selectedTab) {
                Text("My Leagues").tag(0)
                Text("Discover").tag(1)
                Text("Standings").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Content
            ScrollView {
                if selectedTab == 0 {
                    MyLeaguesTab()
                } else if selectedTab == 1 {
                    DiscoverLeaguesTab()
                } else {
                    LeagueStandingsTab()
                }
            }
        }
        .navigationTitle("Leagues")
    }
}

struct MyLeaguesTab: View {
    @EnvironmentObject var socialManager: SocialManager

    var body: some View {
        VStack(spacing: 16) {
            ForEach(socialManager.leagues.prefix(3)) { league in
                LeagueCard(league: league)
            }
        }
        .padding()
    }
}

struct DiscoverLeaguesTab: View {
    @EnvironmentObject var socialManager: SocialManager

    var body: some View {
        VStack(spacing: 16) {
            ForEach(socialManager.leagues.filter { !$0.isPrivate }) { league in
                DiscoverLeagueCard(league: league)
            }
        }
        .padding()
    }
}

struct LeagueStandingsTab: View {
    @State private var standings: [LeagueStanding] = [
        LeagueStanding(id: UUID(), teamID: UUID(), teamName: "Newman Nation", avatarName: "🦬", rank: 1, previousRank: 1, wins: 10, losses: 2, weeklyPoints: 347, totalPoints: 2847, streak: 7),
        LeagueStanding(id: UUID(), teamID: UUID(), teamName: "Garcia Gang", avatarName: "👨‍👩‍👧‍👦", rank: 2, previousRank: 3, wins: 9, losses: 3, weeklyPoints: 312, totalPoints: 2654, streak: 5),
        LeagueStanding(id: UUID(), teamID: UUID(), teamName: "Smith Squad", avatarName: "🦸‍♂️", rank: 3, previousRank: 2, wins: 8, losses: 4, weeklyPoints: 298, totalPoints: 2501, streak: -2),
        LeagueStanding(id: UUID(), teamID: UUID(), teamName: "Johnson Crew", avatarName: "🏠", rank: 4, previousRank: 4, wins: 7, losses: 5, weeklyPoints: 276, totalPoints: 2389, streak: 3)
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(standings) { standing in
                StandingRow(standing: standing)
            }
        }
        .padding()
    }
}

struct LeagueCard: View {
    let league: League

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(league.name)
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    HStack {
                        Image(systemName: league.isPrivate ? "lock.fill" : "globe")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)

                        Text("\(league.memberIDs.count) members")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)

                        Text("•")
                            .foregroundColor(.secondary)

                        Text("Week \(league.currentWeek)/\(league.seasonLength)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }

            Text(league.description)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct DiscoverLeagueCard: View {
    let league: League

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(league.name)
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    HStack {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)

                        Text("\(league.memberIDs.count) members")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(action: {}) {
                    Text("Join")
                        .font(AppFonts.caption())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(AppColors.billsBlue)
                        .cornerRadius(8)
                }
            }

            Text(league.description)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct StandingRow: View {
    let standing: LeagueStanding

    var body: some View {
        HStack(spacing: 12) {
            // Rank
            VStack(spacing: 2) {
                Text("#\(standing.rank)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                if standing.rankChange != 0 {
                    HStack(spacing: 2) {
                        Image(systemName: standing.rankChange > 0 ? "arrow.up" : "arrow.down")
                            .font(.system(size: 8))
                        Text("\(abs(standing.rankChange))")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(standing.rankChange > 0 ? .green : .red)
                }
            }
            .frame(width: 40)

            // Avatar
            Text(standing.avatarName)
                .font(.system(size: 30))

            // Team Info
            VStack(alignment: .leading, spacing: 2) {
                Text(standing.teamName)
                    .font(AppFonts.body())
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    Text("\(standing.wins)-\(standing.losses)")
                        .font(AppFonts.caption())
                        .foregroundColor(.secondary)

                    Text(standing.streakText)
                        .font(AppFonts.caption())
                        .foregroundColor(standing.streak > 0 ? .green : .red)
                }
            }

            Spacer()

            // Points
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(standing.totalPoints)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.billsBlue)

                Text("\(standing.weeklyPoints) this week")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(standing.rank == 1 ? AppColors.gold.opacity(0.1) : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(standing.rank == 1 ? AppColors.gold : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

// MARK: - Groups Hub View

struct GroupsHubView: View {
    @EnvironmentObject var socialManager: SocialManager
    @State private var selectedCategory: CommunityGroup.GroupCategory? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CategoryButton(title: "All", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }

                    ForEach(CommunityGroup.GroupCategory.allCases, id: \.self) { category in
                        CategoryButton(title: category.rawValue, isSelected: selectedCategory == category) {
                            selectedCategory = category
                        }
                    }
                }
                .padding()
            }

            // Groups List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredGroups) { group in
                        GroupCard(group: group)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Groups")
    }

    var filteredGroups: [CommunityGroup] {
        if let category = selectedCategory {
            return socialManager.groups.filter { $0.category == category }
        }
        return socialManager.groups
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(isSelected ? .white : AppColors.billsBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.billsBlue : Color(.systemGray6))
                .cornerRadius(20)
        }
    }
}

struct GroupCard: View {
    @EnvironmentObject var socialManager: SocialManager
    let group: CommunityGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: group.category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.billsBlue)
                    .frame(width: 40, height: 40)
                    .background(AppColors.billsBlue.opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(AppFonts.body())
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    HStack {
                        Text("\(group.memberCount) members")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)

                        Text("•")
                            .foregroundColor(.secondary)

                        HStack(spacing: 4) {
                            Circle()
                                .fill(group.activityLevel.color)
                                .frame(width: 6, height: 6)

                            Text(group.activityLevel.rawValue)
                                .font(AppFonts.caption())
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                Button(action: {
                    socialManager.toggleGroupMembership(group: group)
                }) {
                    Text(group.isJoined ? "Joined" : "Join")
                        .font(AppFonts.caption())
                        .foregroundColor(group.isJoined ? .secondary : .white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(group.isJoined ? Color(.systemGray5) : AppColors.billsBlue)
                        .cornerRadius(8)
                }
            }

            Text(group.description)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

// MARK: - Notifications View

struct NotificationsView: View {
    @EnvironmentObject var socialManager: SocialManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    if !socialManager.notifications.isEmpty {
                        ForEach(socialManager.notifications) { notification in
                            NotificationRow(notification: notification)
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "bell.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)

                            Text("No notifications yet")
                                .font(AppFonts.body())
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    }
                }
                .padding()
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if socialManager.unreadNotificationCount > 0 {
                        Button("Mark All Read") {
                            socialManager.markAllNotificationsAsRead()
                        }
                        .font(AppFonts.caption())
                        .foregroundColor(AppColors.billsBlue)
                    }
                }
            }
        }
    }
}

struct NotificationRow: View {
    @EnvironmentObject var socialManager: SocialManager
    let notification: SocialNotification

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.type.color.opacity(0.1))
                    .frame(width: 40, height: 40)

                Image(systemName: notification.type.icon)
                    .foregroundColor(notification.type.color)
                    .font(.system(size: 16))
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.senderName)
                        .font(AppFonts.body())
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(notification.content)
                        .font(AppFonts.body())
                        .foregroundColor(.secondary)
                }

                Text(timeAgoString(from: notification.timestamp))
                    .font(AppFonts.caption())
                    .foregroundColor(.secondary)
            }

            Spacer()

            if !notification.isRead {
                Circle()
                    .fill(AppColors.billsBlue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(notification.isRead ? Color.white : AppColors.billsBlue.opacity(0.05))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 2)
        .onTapGesture {
            socialManager.markNotificationAsRead(notification)
        }
    }

    func timeAgoString(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 { return "Just now" }
        if seconds < 3600 { return "\(seconds / 60)m ago" }
        if seconds < 86400 { return "\(seconds / 3600)h ago" }
        return "\(seconds / 86400)d ago"
    }
}
