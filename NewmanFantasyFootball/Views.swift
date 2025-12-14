import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Team Header
                    TeamHeaderCard()

                    // Quick Stats
                    QuickStatsGrid()

                    // Today's Tasks
                    TodaysTasksSection()

                    // Weekly Challenges Preview
                    WeeklyChallengesPreview()
                }
                .padding()
            }
            .navigationTitle("Home")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct TeamHeaderCard: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(gameManager.teamAvatar)
                    .font(.system(size: 60))

                VStack(alignment: .leading, spacing: 4) {
                    Text(gameManager.teamName)
                        .font(AppFonts.title())
                        .foregroundColor(AppColors.billsBlue)

                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(gameManager.currentStreak) Day Streak")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack {
                    Text("\(gameManager.totalPoints)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.billsBlue)
                    Text("Total Points")
                        .font(AppFonts.caption())
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5)
        }
    }
}

struct QuickStatsGrid: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(icon: "person.3.fill", title: "Roster", value: "\(gameManager.players.count)", color: AppColors.billsBlue)
            StatCard(icon: "checkmark.circle.fill", title: "Tasks Today", value: "\(gameManager.tasks.filter { $0.isCompleted }.count)/\(gameManager.tasks.count)", color: .green)
            StatCard(icon: "trophy.fill", title: "Achievements", value: "\(gameManager.achievements.filter { $0.isUnlocked }.count)", color: .orange)
            StatCard(icon: "target", title: "Challenges", value: "\(gameManager.weeklyChallenges.count)", color: AppColors.billsRed)
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct TodaysTasksSection: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Tasks")
                    .font(AppFonts.headline())
                    .foregroundColor(.primary)
                Spacer()
                NavigationLink("View All") {
                    PlaybookView()
                }
                .font(AppFonts.caption())
                .foregroundColor(AppColors.billsBlue)
            }

            ForEach(gameManager.tasks.prefix(3)) { task in
                TaskRowView(task: task)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct TaskRowView: View {
    @EnvironmentObject var gameManager: GameManager
    let task: Task

    var body: some View {
        HStack {
            Image(systemName: task.category.icon)
                .foregroundColor(AppColors.billsBlue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(AppFonts.body())
                    .foregroundColor(.primary)

                Text("\(task.pointValue) pts")
                    .font(AppFonts.caption())
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                gameManager.completeTask(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.system(size: 24))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WeeklyChallengesPreview: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weekly Challenges")
                    .font(AppFonts.headline())
                    .foregroundColor(.primary)
                Spacer()
                NavigationLink("View All") {
                    WeeklyChallengesView()
                }
                .font(AppFonts.caption())
                .foregroundColor(AppColors.billsBlue)
            }

            ForEach(gameManager.weeklyChallenges.prefix(2)) { challenge in
                ChallengeRowView(challenge: challenge)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct ChallengeRowView: View {
    let challenge: WeeklyChallenge

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(challenge.title)
                    .font(AppFonts.body())
                    .foregroundColor(.primary)
                Spacer()
                Text("+\(challenge.pointReward) pts")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.billsBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.billsBlue.opacity(0.1))
                    .cornerRadius(8)
            }

            ProgressView(value: challenge.progressPercentage)
                .tint(AppColors.billsBlue)

            Text("\(challenge.currentProgress)/\(challenge.targetCount) completed")
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Roster View

struct RosterView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showingAddPlayer = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(gameManager.players) { player in
                        PlayerCard(player: player)
                    }

                    Button(action: { showingAddPlayer = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Player")
                        }
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.billsBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Roster")
            .sheet(isPresented: $showingAddPlayer) {
                CreatePlayerView()
            }
        }
    }
}

struct PlayerCard: View {
    let player: Player

    var body: some View {
        HStack(spacing: 16) {
            Text(player.avatarName)
                .font(.system(size: 50))

            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(AppFonts.headline())
                    .foregroundColor(.primary)

                Text(player.position.displayName)
                    .font(AppFonts.caption())
                    .foregroundColor(.secondary)

                HStack {
                    Text("OVR \(player.overallRating)")
                        .font(AppFonts.caption())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(AppColors.billsBlue)
                        .cornerRadius(4)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(player.stats.totalPoints) pts")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.billsBlue)

                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(player.stats.currentStreak)")
                        .font(AppFonts.caption())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

// MARK: - Playbook View

struct PlaybookView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var selectedCategory: Task.TaskCategory? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        CategoryFilterButton(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }

                        ForEach(Task.TaskCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(title: category.rawValue, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Tasks List
                ForEach(filteredTasks) { task in
                    TaskRowView(task: task)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Playbook")
    }

    var filteredTasks: [Task] {
        if let category = selectedCategory {
            return gameManager.tasks.filter { $0.category == category }
        }
        return gameManager.tasks
    }
}

struct CategoryFilterButton: View {
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

// MARK: - Achievements View

struct AchievementsView: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(gameManager.achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
                .padding()
            }
            .navigationTitle("Achievements")
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 16) {
            Text(achievement.icon)
                .font(.system(size: 50))
                .opacity(achievement.isUnlocked ? 1.0 : 0.3)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(achievement.title)
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    Spacer()

                    Text(achievement.tier.rawValue)
                        .font(AppFonts.caption())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(achievement.tier.color)
                        .cornerRadius(8)
                }

                Text(achievement.description)
                    .font(AppFonts.caption())
                    .foregroundColor(.secondary)

                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progressPercentage)
                        .tint(achievement.tier.color)

                    Text("\(achievement.currentProgress)/\(achievement.requirement)")
                        .font(AppFonts.caption())
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - Team Customization View

struct TeamCustomizationView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var teamName: String = ""
    @State private var selectedAvatar: String = "🦬"
    @Environment(\.dismiss) var dismiss

    let avatarOptions = ["🦬", "🏈", "⚡", "🔥", "👨‍👩‍👧‍👦", "🏠", "⭐", "💪", "🛡️", "👑"]

    var body: some View {
        NavigationView {
            Form {
                Section("Team Name") {
                    TextField("Enter team name", text: $teamName)
                }

                Section("Team Avatar") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(avatarOptions, id: \.self) { avatar in
                            Button(action: { selectedAvatar = avatar }) {
                                Text(avatar)
                                    .font(.system(size: 40))
                                    .padding()
                                    .background(selectedAvatar == avatar ? AppColors.billsBlue.opacity(0.2) : Color(.systemGray6))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Customize Team")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    gameManager.updateTeamInfo(name: teamName, avatar: selectedAvatar)
                    dismiss()
                }
            )
            .onAppear {
                teamName = gameManager.teamName
                selectedAvatar = gameManager.teamAvatar
            }
        }
    }
}
