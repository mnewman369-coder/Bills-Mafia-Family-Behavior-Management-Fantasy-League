import SwiftUI

// MARK: - Social Data Models

struct League: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var commissionerID: UUID
    var memberIDs: [UUID]
    var isPrivate: Bool
    var seasonLength: Int // in weeks
    var currentWeek: Int
    var currentSeason: Int
    var seasonStartDate: Date
    var scoringMultipliers: ScoringMultipliers
    var leagueType: LeagueType

    enum LeagueType: String, Codable, CaseIterable {
        case headToHead = "Head-to-Head"
        case pointsBased = "Points-Based"
    }

    struct ScoringMultipliers: Codable {
        var dailyTasks: Double = 1.0
        var weeklyGoals: Double = 1.0
        var achievements: Double = 1.0
        var streakBonus: Double = 1.0
    }

    init(id: UUID = UUID(), name: String, description: String, commissionerID: UUID, isPrivate: Bool = false, seasonLength: Int = 17, leagueType: LeagueType = .pointsBased) {
        self.id = id
        self.name = name
        self.description = description
        self.commissionerID = commissionerID
        self.memberIDs = [commissionerID]
        self.isPrivate = isPrivate
        self.seasonLength = seasonLength
        self.currentWeek = 1
        self.currentSeason = 1
        self.seasonStartDate = Date()
        self.scoringMultipliers = ScoringMultipliers()
        self.leagueType = leagueType
    }
}

struct LeagueStanding: Identifiable {
    let id: UUID
    let teamID: UUID
    let teamName: String
    let avatarName: String
    var rank: Int
    var previousRank: Int
    var wins: Int
    var losses: Int
    var weeklyPoints: Int
    var totalPoints: Int
    var streak: Int // positive for wins, negative for losses

    var rankChange: Int {
        previousRank - rank
    }

    var streakText: String {
        if streak > 0 {
            return "W\(streak)"
        } else if streak < 0 {
            return "L\(abs(streak))"
        }
        return "-"
    }
}

struct CommunityGroup: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var category: GroupCategory
    var memberCount: Int
    var rules: [String]
    var moderatorIDs: [UUID]
    var isJoined: Bool
    var lastActivityDate: Date
    var activityLevel: ActivityLevel

    enum GroupCategory: String, Codable, CaseIterable {
        case general = "General"
        case newParents = "New Parents"
        case toddlerLife = "Toddler Life"
        case schoolAge = "School Age Kids"
        case teens = "Teens"
        case grandparents = "Grandparents"
        case healthFitness = "Health & Fitness"
        case faithValues = "Faith & Values"
        case regional = "Regional"
        case sportsFans = "Sports Fans"

        var icon: String {
            switch self {
            case .general: return "person.3"
            case .newParents: return "figure.and.child.holdinghands"
            case .toddlerLife: return "figure.walk"
            case .schoolAge: return "backpack"
            case .teens: return "figure.wave"
            case .grandparents: return "heart"
            case .healthFitness: return "figure.run"
            case .faithValues: return "sparkles"
            case .regional: return "map"
            case .sportsFans: return "sportscourt"
            }
        }
    }

    enum ActivityLevel: String, Codable {
        case veryActive = "Very Active"
        case active = "Active"
        case moderate = "Moderate"
        case quiet = "Quiet"

        var color: Color {
            switch self {
            case .veryActive: return .green
            case .active: return .blue
            case .moderate: return .orange
            case .quiet: return .gray
            }
        }
    }
}

struct SocialPost: Identifiable, Codable {
    let id: UUID
    var authorID: UUID
    var authorName: String
    var authorAvatar: String
    var postType: PostType
    var content: String
    var timestamp: Date
    var likeCount: Int
    var commentCount: Int
    var shareCount: Int
    var isLiked: Bool
    var leagueID: UUID?
    var groupID: UUID?
    var achievementID: UUID?
    var imageNames: [String]

    enum PostType: String, Codable, CaseIterable {
        case achievement = "Achievement"
        case milestone = "Milestone"
        case celebration = "Celebration"
        case question = "Question"
        case tip = "Tip"
        case update = "Update"
        case challenge = "Challenge"
        case photoShare = "Photo Share"

        var icon: String {
            switch self {
            case .achievement: return "trophy.fill"
            case .milestone: return "flag.fill"
            case .celebration: return "party.popper.fill"
            case .question: return "questionmark.circle.fill"
            case .tip: return "lightbulb.fill"
            case .update: return "newspaper.fill"
            case .challenge: return "flame.fill"
            case .photoShare: return "photo.fill"
            }
        }

        var color: Color {
            switch self {
            case .achievement: return .yellow
            case .milestone: return .purple
            case .celebration: return .pink
            case .question: return .blue
            case .tip: return .green
            case .update: return .cyan
            case .challenge: return .orange
            case .photoShare: return .indigo
            }
        }
    }

    init(id: UUID = UUID(), authorID: UUID, authorName: String, authorAvatar: String, postType: PostType, content: String, timestamp: Date = Date(), leagueID: UUID? = nil, groupID: UUID? = nil, achievementID: UUID? = nil) {
        self.id = id
        self.authorID = authorID
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.postType = postType
        self.content = content
        self.timestamp = timestamp
        self.likeCount = 0
        self.commentCount = 0
        self.shareCount = 0
        self.isLiked = false
        self.leagueID = leagueID
        self.groupID = groupID
        self.achievementID = achievementID
        self.imageNames = []
    }
}

struct PostComment: Identifiable, Codable {
    let id: UUID
    let postID: UUID
    var authorID: UUID
    var authorName: String
    var authorAvatar: String
    var content: String
    var timestamp: Date
    var likeCount: Int
    var isLiked: Bool
}

struct TeamProfile: Identifiable {
    let id: UUID
    var teamName: String
    var avatarName: String
    var bio: String
    var followerCount: Int
    var followingCount: Int
    var isFollowing: Bool
    var seasonPoints: Int
    var dayStreak: Int
    var achievementCount: Int
    var leagueRank: Int?
    var recentPosts: [SocialPost]
    var recentAchievements: [String]
    var stats: TeamStats

    struct TeamStats {
        var totalPoints: Int
        var tasksCompleted: Int
        var goalsAchieved: Int
        var bestStreak: Int
        var categoryBreakdown: [String: Int]
    }
}

struct SocialNotification: Identifiable, Codable {
    let id: UUID
    var type: NotificationType
    var senderID: UUID
    var senderName: String
    var senderAvatar: String
    var content: String
    var timestamp: Date
    var isRead: Bool
    var relatedPostID: UUID?
    var relatedLeagueID: UUID?

    enum NotificationType: String, Codable {
        case like = "Like"
        case comment = "Comment"
        case follow = "Follow"
        case leagueInvite = "League Invite"
        case achievementCelebration = "Achievement"
        case mention = "Mention"

        var icon: String {
            switch self {
            case .like: return "heart.fill"
            case .comment: return "bubble.left.fill"
            case .follow: return "person.badge.plus.fill"
            case .leagueInvite: return "envelope.fill"
            case .achievementCelebration: return "trophy.fill"
            case .mention: return "at"
            }
        }

        var color: Color {
            switch self {
            case .like: return .pink
            case .comment: return .blue
            case .follow: return .purple
            case .leagueInvite: return .green
            case .achievementCelebration: return .yellow
            case .mention: return .orange
            }
        }
    }
}

// MARK: - Social Manager

@MainActor
class SocialManager: ObservableObject {
    @Published var leagues: [League] = []
    @Published var groups: [CommunityGroup] = []
    @Published var posts: [SocialPost] = []
    @Published var notifications: [SocialNotification] = []
    @Published var currentUserProfile: TeamProfile?

    init() {
        loadSampleData()
    }

    func loadSampleData() {
        // Sample Leagues
        leagues = [
            League(name: "Newman Family League", description: "Our family's private league", commissionerID: UUID(), isPrivate: true, seasonLength: 17),
            League(name: "Western NY Bills Mafia Families", description: "Buffalo area families competing together", commissionerID: UUID(), isPrivate: false, seasonLength: 14),
            League(name: "Faith & Family Champions", description: "Christian families building strong homes", commissionerID: UUID(), isPrivate: false, seasonLength: 12)
        ]

        // Sample Groups
        groups = [
            CommunityGroup(id: UUID(), name: "Bills Mafia Families 🦬", description: "For families who bleed blue and red. Let's go Buffalo!", category: .sportsFans, memberCount: 2847, rules: ["Keep it family-friendly", "No trash talk", "Support each other"], moderatorIDs: [], isJoined: true, lastActivityDate: Date(), activityLevel: .veryActive),

            CommunityGroup(id: UUID(), name: "Toddler Parent Wins", description: "Celebrating the small victories in the trenches of toddlerhood", category: .toddlerLife, memberCount: 1523, rules: ["Share tips and encouragement", "No judgment zone", "Celebrate all wins"], moderatorIDs: [], isJoined: true, lastActivityDate: Date().addingTimeInterval(-3600), activityLevel: .active),

            CommunityGroup(id: UUID(), name: "Central Florida Families", description: "Connecting families in the Orlando/Tampa area", category: .regional, memberCount: 892, rules: ["Local events welcome", "Be neighborly", "Share community resources"], moderatorIDs: [], isJoined: false, lastActivityDate: Date().addingTimeInterval(-7200), activityLevel: .moderate),

            CommunityGroup(id: UUID(), name: "Faith-First Families", description: "Putting God at the center of family life", category: .faithValues, memberCount: 3421, rules: ["Respectful dialogue", "Share testimonies", "Pray for each other"], moderatorIDs: [], isJoined: true, lastActivityDate: Date().addingTimeInterval(-1800), activityLevel: .veryActive),

            CommunityGroup(id: UUID(), name: "New Parent Support Circle", description: "For parents with babies 0-12 months", category: .newParents, memberCount: 1056, rules: ["Ask anything", "Share experiences", "Support not advice"], moderatorIDs: [], isJoined: false, lastActivityDate: Date().addingTimeInterval(-5400), activityLevel: .active),

            CommunityGroup(id: UUID(), name: "School-Age Success", description: "Navigating homework, activities, and growing independence", category: .schoolAge, memberCount: 2134, rules: ["Share strategies", "Celebrate achievements", "Problem-solve together"], moderatorIDs: [], isJoined: false, lastActivityDate: Date().addingTimeInterval(-10800), activityLevel: .moderate)
        ]

        // Sample Posts
        posts = [
            SocialPost(authorID: UUID(), authorName: "Garcia Gang", authorAvatar: "👨‍👩‍👧‍👦", postType: .tip, content: "Game-changer tip: We started doing 'Friday Family Film Fest' where the kids earn movie choice by completing their weekly goals. Engagement is through the roof! 🎬", timestamp: Date().addingTimeInterval(-3600)),

            SocialPost(authorID: UUID(), authorName: "Smith Squad", authorAvatar: "🦸‍♂️", postType: .achievement, content: "Just unlocked PLATINUM TIER: The Unbreakable! 14-day streak and counting! 🔥💪", timestamp: Date().addingTimeInterval(-7200)),

            SocialPost(authorID: UUID(), authorName: "Johnson Crew", authorAvatar: "🏠", postType: .celebration, content: "Our 3-year-old put his toys away WITHOUT being asked! This app is working miracles! 🙌", timestamp: Date().addingTimeInterval(-10800)),

            SocialPost(authorID: UUID(), authorName: "Rodriguez Family", authorAvatar: "⚡", postType: .question, content: "How do you handle it when one kid completes tasks but the other doesn't? Don't want to penalize the whole team...", timestamp: Date().addingTimeInterval(-14400)),

            SocialPost(authorID: UUID(), authorName: "Williams Warriors", authorAvatar: "🛡️", postType: .milestone, content: "MILESTONE ALERT: 100 total achievements unlocked! Started this journey 6 months ago and our family dynamic has completely transformed. Thank you to this amazing community! ❤️", timestamp: Date().addingTimeInterval(-18000))
        ]

        // Add some likes and comments to posts
        if !posts.isEmpty {
            posts[0].likeCount = 47
            posts[0].commentCount = 12

            posts[1].likeCount = 89
            posts[1].commentCount = 23
            posts[1].isLiked = true

            posts[2].likeCount = 156
            posts[2].commentCount = 34
        }

        // Sample Notifications
        notifications = [
            SocialNotification(id: UUID(), type: .like, senderID: UUID(), senderName: "Garcia Gang", senderAvatar: "👨‍👩‍👧‍👦", content: "liked your post", timestamp: Date().addingTimeInterval(-600), isRead: false),

            SocialNotification(id: UUID(), type: .comment, senderID: UUID(), senderName: "Smith Squad", senderAvatar: "🦸‍♂️", content: "commented: 'Awesome achievement! We're right behind you!'", timestamp: Date().addingTimeInterval(-1800), isRead: false),

            SocialNotification(id: UUID(), type: .follow, senderID: UUID(), senderName: "Johnson Crew", senderAvatar: "🏠", content: "started following you", timestamp: Date().addingTimeInterval(-3600), isRead: false),

            SocialNotification(id: UUID(), type: .leagueInvite, senderID: UUID(), senderName: "Martinez Family", senderAvatar: "🌟", content: "invited you to join 'Regional Champions League'", timestamp: Date().addingTimeInterval(-7200), isRead: true),

            SocialNotification(id: UUID(), type: .achievementCelebration, senderID: UUID(), senderName: "Davis Dynasty", senderAvatar: "👑", content: "unlocked the same achievement as you: The Unbreakable", timestamp: Date().addingTimeInterval(-10800), isRead: true)
        ]
    }

    // Social Actions
    func toggleLike(post: SocialPost) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isLiked.toggle()
            posts[index].likeCount += posts[index].isLiked ? 1 : -1
        }
    }

    func addComment(to post: SocialPost, content: String) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].commentCount += 1
        }
    }

    func sharePost(_ post: SocialPost) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].shareCount += 1
        }
    }

    func createPost(_ post: SocialPost) {
        posts.insert(post, at: 0)
    }

    func toggleGroupMembership(group: CommunityGroup) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].isJoined.toggle()
            groups[index].memberCount += groups[index].isJoined ? 1 : -1
        }
    }

    func joinLeague(_ league: League) {
        // Implementation for joining leagues
    }

    func markNotificationAsRead(_ notification: SocialNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
    }

    func markAllNotificationsAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }

    var unreadNotificationCount: Int {
        notifications.filter { !$0.isRead }.count
    }
}
