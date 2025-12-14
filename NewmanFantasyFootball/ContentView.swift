import SwiftUI

// MARK: - Core Data Models

struct Player: Identifiable, Codable {
    let id: UUID
    var name: String
    var position: Position
    var avatarName: String
    var overallRating: Int
    var stats: PlayerStats
    var isActive: Bool
    var customNotes: String

    enum Position: String, Codable, CaseIterable {
        case quarterback = "QB"
        case runningBack = "RB"
        case wideReceiver = "WR"
        case tightEnd = "TE"
        case offensiveLine = "OL"
        case defensiveLine = "DL"
        case linebacker = "LB"
        case defensiveBack = "DB"
        case kicker = "K"
        case punter = "P"

        var displayName: String {
            switch self {
            case .quarterback: return "Quarterback (Leader)"
            case .runningBack: return "Running Back (Worker)"
            case .wideReceiver: return "Wide Receiver (Quick Learner)"
            case .tightEnd: return "Tight End (Versatile)"
            case .offensiveLine: return "Offensive Line (Foundation)"
            case .defensiveLine: return "Defensive Line (Protector)"
            case .linebacker: return "Linebacker (Enforcer)"
            case .defensiveBack: return "Defensive Back (Strategic)"
            case .kicker: return "Kicker (Clutch)"
            case .punter: return "Punter (Specialist)"
            }
        }
    }

    struct PlayerStats: Codable {
        var tasksCompleted: Int = 0
        var totalPoints: Int = 0
        var currentStreak: Int = 0
        var bestStreak: Int = 0
        var missedTasks: Int = 0
        var achievementsUnlocked: Int = 0
    }

    init(id: UUID = UUID(), name: String, position: Position, avatarName: String = "👤") {
        self.id = id
        self.name = name
        self.position = position
        self.avatarName = avatarName
        self.overallRating = 70
        self.stats = PlayerStats()
        self.isActive = true
        self.customNotes = ""
    }
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var pointValue: Int
    var category: TaskCategory
    var frequency: Frequency
    var assignedPlayerIDs: [UUID]
    var isCompleted: Bool
    var completionDate: Date?
    var streakCount: Int

    enum TaskCategory: String, Codable, CaseIterable {
        case chores = "Chores"
        case homework = "Homework"
        case reading = "Reading"
        case exercise = "Exercise"
        case familyTime = "Family Time"
        case character = "Character"
        case creativity = "Creativity"
        case selfCare = "Self-Care"

        var icon: String {
            switch self {
            case .chores: return "house.fill"
            case .homework: return "book.fill"
            case .reading: return "text.book.closed.fill"
            case .exercise: return "figure.run"
            case .familyTime: return "heart.fill"
            case .character: return "star.fill"
            case .creativity: return "paintbrush.fill"
            case .selfCare: return "sparkles"
            }
        }
    }

    enum Frequency: String, Codable, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case custom = "Custom"
    }

    init(id: UUID = UUID(), title: String, description: String, pointValue: Int, category: TaskCategory, frequency: Frequency = .daily) {
        self.id = id
        self.title = title
        self.description = description
        self.pointValue = pointValue
        self.category = category
        self.frequency = frequency
        self.assignedPlayerIDs = []
        self.isCompleted = false
        self.completionDate = nil
        self.streakCount = 0
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var icon: String
    var tier: Tier
    var requirement: Int
    var currentProgress: Int
    var isUnlocked: Bool
    var unlockedDate: Date?

    enum Tier: String, Codable {
        case bronze = "Bronze"
        case silver = "Silver"
        case gold = "Gold"
        case platinum = "Platinum"

        var color: Color {
            switch self {
            case .bronze: return Color(red: 0.8, green: 0.5, blue: 0.2)
            case .silver: return Color(red: 0.75, green: 0.75, blue: 0.75)
            case .gold: return Color(red: 1.0, green: 0.84, blue: 0.0)
            case .platinum: return Color(red: 0.9, green: 0.95, blue: 1.0)
            }
        }
    }

    var progressPercentage: Double {
        min(Double(currentProgress) / Double(requirement), 1.0)
    }
}

struct WeeklyChallenge: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var pointReward: Int
    var category: Task.TaskCategory
    var targetCount: Int
    var currentProgress: Int
    var isCompleted: Bool
    var weekNumber: Int

    var progressPercentage: Double {
        min(Double(currentProgress) / Double(targetCount), 1.0)
    }
}

// MARK: - Theme & Styling

struct AppColors {
    static let billsBlue = Color(red: 0/255, green: 51/255, blue: 141/255)
    static let billsRed = Color(red: 198/255, green: 12/255, blue: 48/255)
    static let fieldGreen = Color(red: 34/255, green: 139/255, blue: 34/255)
    static let bronze = Color(red: 205/255, green: 127/255, blue: 50/255)
    static let silver = Color(red: 192/255, green: 192/255, blue: 192/255)
    static let gold = Color(red: 255/255, green: 215/255, blue: 0/255)
    static let platinum = Color(red: 229/255, green: 242/255, blue: 255/255)
}

struct AppFonts {
    static func title() -> Font { .system(size: 28, weight: .bold, design: .rounded) }
    static func headline() -> Font { .system(size: 20, weight: .semibold, design: .rounded) }
    static func body() -> Font { .system(size: 16, weight: .regular, design: .rounded) }
    static func caption() -> Font { .system(size: 14, weight: .medium, design: .rounded) }
}

// MARK: - App Entry Point

@main
struct NewmanFantasyFootballApp: App {
    @StateObject private var gameManager = GameManager()
    @StateObject private var socialManager = SocialManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(gameManager)
                .environmentObject(socialManager)
        }
    }
}

// MARK: - Game Manager

@MainActor
class GameManager: ObservableObject {
    @Published var teamName: String = "Newman Nation"
    @Published var teamAvatar: String = "🦬"
    @Published var totalPoints: Int = 2847
    @Published var currentStreak: Int = 7
    @Published var players: [Player] = []
    @Published var tasks: [Task] = []
    @Published var achievements: [Achievement] = []
    @Published var weeklyChallenges: [WeeklyChallenge] = []

    init() {
        loadSampleData()
    }

    func loadSampleData() {
        // Sample Players
        players = [
            Player(name: "Jack Newman", position: .quarterback, avatarName: "👦"),
            Player(name: "Lillie Newman", position: .wideReceiver, avatarName: "👧")
        ]

        // Sample Tasks
        tasks = [
            Task(title: "Morning Routine", description: "Brush teeth, get dressed, make bed", pointValue: 10, category: .selfCare),
            Task(title: "Homework Time", description: "Complete daily assignments", pointValue: 15, category: .homework),
            Task(title: "Chore Duty", description: "Clean room and help with dishes", pointValue: 20, category: .chores),
            Task(title: "Reading Time", description: "Read for 20 minutes", pointValue: 10, category: .reading),
            Task(title: "Family Dinner", description: "Participate in family meal", pointValue: 15, category: .familyTime)
        ]

        // Sample Achievements
        achievements = [
            Achievement(id: UUID(), title: "The Rookie", description: "Complete your first task", icon: "🏈", tier: .bronze, requirement: 1, currentProgress: 1, isUnlocked: true, unlockedDate: Date()),
            Achievement(id: UUID(), title: "The Reliable", description: "Complete 10 tasks in a row", icon: "⭐", tier: .silver, requirement: 10, currentProgress: 7, isUnlocked: false, unlockedDate: nil),
            Achievement(id: UUID(), title: "The Champion", description: "Maintain a 30-day streak", icon: "🏆", tier: .gold, requirement: 30, currentProgress: 7, isUnlocked: false, unlockedDate: nil),
            Achievement(id: UUID(), title: "The Unbreakable", description: "Never miss a task for 90 days", icon: "💎", tier: .platinum, requirement: 90, currentProgress: 7, isUnlocked: false, unlockedDate: nil)
        ]

        // Sample Weekly Challenges
        weeklyChallenges = [
            WeeklyChallenge(id: UUID(), title: "Reading Marathon", description: "Read for 30 minutes every day this week", pointReward: 100, category: .reading, targetCount: 7, currentProgress: 4, isCompleted: false, weekNumber: 1),
            WeeklyChallenge(id: UUID(), title: "Chore Champion", description: "Complete all chores without reminders", pointReward: 150, category: .chores, targetCount: 7, currentProgress: 4, isCompleted: false, weekNumber: 1)
        ]
    }

    func completeTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
            tasks[index].completionDate = Date()
            tasks[index].streakCount += 1
            totalPoints += tasks[index].pointValue
            currentStreak += 1
        }
    }

    func addPlayer(_ player: Player) {
        players.append(player)
    }

    func updateTeamInfo(name: String, avatar: String) {
        teamName = name
        teamAvatar = avatar
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var socialManager: SocialManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            RosterView()
                .tabItem {
                    Label("Roster", systemImage: "person.3.fill")
                }
                .tag(1)

            CommunityFeedView()
                .tabItem {
                    Label("Community", systemImage: "person.2.fill")
                }
                .tag(2)

            AchievementsView()
                .tabItem {
                    Label("Achievements", systemImage: "trophy.fill")
                }
                .tag(3)

            MoreMenuView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }
                .tag(4)
        }
        .accentColor(AppColors.billsBlue)
    }
}
