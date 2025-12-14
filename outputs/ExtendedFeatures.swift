import SwiftUI

// MARK: - Create Player View

struct CreatePlayerView: View {
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss

    @State private var currentStep = 0
    @State private var playerName = ""
    @State private var selectedPosition: Player.Position = .quarterback
    @State private var selectedAvatar = "👤"

    let avatarOptions = ["👦", "👧", "🧒", "👶", "👨", "👩", "🧑", "👴", "👵"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress Indicator
                ProgressView(value: Double(currentStep), total: 2)
                    .padding()

                // Step Content
                switch currentStep {
                case 0:
                    NameStepView(playerName: $playerName)
                case 1:
                    PositionStepView(selectedPosition: $selectedPosition)
                case 2:
                    AvatarStepView(selectedAvatar: $selectedAvatar, avatarOptions: avatarOptions)
                default:
                    EmptyView()
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            currentStep -= 1
                        }
                        .foregroundColor(AppColors.billsBlue)
                    }

                    Spacer()

                    if currentStep < 2 {
                        Button("Next") {
                            currentStep += 1
                        }
                        .disabled(currentStep == 0 && playerName.isEmpty)
                        .foregroundColor(AppColors.billsBlue)
                    } else {
                        Button("Create Player") {
                            let newPlayer = Player(name: playerName, position: selectedPosition, avatarName: selectedAvatar)
                            gameManager.addPlayer(newPlayer)
                            dismiss()
                        }
                        .disabled(playerName.isEmpty)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(AppColors.billsBlue)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Create Player")
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}

struct NameStepView: View {
    @Binding var playerName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Step 1: Player Name")
                .font(AppFonts.title())
                .foregroundColor(AppColors.billsBlue)

            Text("What's this player's name?")
                .font(AppFonts.body())
                .foregroundColor(.secondary)

            TextField("Enter name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(AppFonts.body())
                .padding(.top)
        }
        .padding()
    }
}

struct PositionStepView: View {
    @Binding var selectedPosition: Player.Position

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Step 2: Choose Position")
                .font(AppFonts.title())
                .foregroundColor(AppColors.billsBlue)

            Text("Each position represents a different role in your family team")
                .font(AppFonts.body())
                .foregroundColor(.secondary)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Player.Position.allCases, id: \.self) { position in
                        Button(action: { selectedPosition = position }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(position.rawValue)
                                        .font(AppFonts.headline())
                                        .foregroundColor(.primary)
                                    Text(position.displayName)
                                        .font(AppFonts.caption())
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if selectedPosition == position {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppColors.billsBlue)
                                }
                            }
                            .padding()
                            .background(selectedPosition == position ? AppColors.billsBlue.opacity(0.1) : Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct AvatarStepView: View {
    @Binding var selectedAvatar: String
    let avatarOptions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Step 3: Pick Avatar")
                .font(AppFonts.title())
                .foregroundColor(AppColors.billsBlue)

            Text("Choose an avatar to represent this player")
                .font(AppFonts.body())
                .foregroundColor(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 16) {
                ForEach(avatarOptions, id: \.self) { avatar in
                    Button(action: { selectedAvatar = avatar }) {
                        Text(avatar)
                            .font(.system(size: 50))
                            .padding()
                            .background(selectedAvatar == avatar ? AppColors.billsBlue.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

// MARK: - Weekly Challenges View

struct WeeklyChallengesView: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Week \(gameManager.weeklyChallenges.first?.weekNumber ?? 1) Challenges")
                        .font(AppFonts.title())
                        .foregroundColor(AppColors.billsBlue)

                    Text("Complete these challenges for bonus points!")
                        .font(AppFonts.body())
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                // Challenges List
                ForEach(gameManager.weeklyChallenges) { challenge in
                    WeeklyChallengeCard(challenge: challenge)
                }
            }
            .padding()
        }
        .navigationTitle("Weekly Challenges")
    }
}

struct WeeklyChallengeCard: View {
    let challenge: WeeklyChallenge

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: challenge.category.icon)
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.billsBlue)

                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    Text(challenge.description)
                        .font(AppFonts.caption())
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            // Progress Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(AppFonts.caption())
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("\(challenge.currentProgress)/\(challenge.targetCount)")
                        .font(AppFonts.body())
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.billsBlue)
                }

                ProgressView(value: challenge.progressPercentage)
                    .tint(AppColors.billsBlue)
            }

            // Reward Badge
            HStack {
                Spacer()
                Text("+\(challenge.pointReward) Points")
                    .font(AppFonts.body())
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [AppColors.billsBlue, AppColors.billsRed],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                Spacer()
            }

            if challenge.isCompleted {
                HStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Completed!")
                    }
                    .foregroundColor(.green)
                    .font(AppFonts.body())
                    .fontWeight(.bold)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

// MARK: - Statistics Dashboard

struct StatisticsDashboardView: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Overall Team Stats
                TeamStatsOverview()

                // Category Breakdown
                CategoryBreakdownSection()

                // Player Performance
                PlayerPerformanceSection()

                // Trends Chart
                TrendsSection()
            }
            .padding()
        }
        .navigationTitle("Statistics")
    }
}

struct TeamStatsOverview: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Team Overview")
                .font(AppFonts.headline())
                .foregroundColor(.primary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatBox(title: "Total Points", value: "\(gameManager.totalPoints)", icon: "star.fill", color: AppColors.billsBlue)
                StatBox(title: "Current Streak", value: "\(gameManager.currentStreak) days", icon: "flame.fill", color: .orange)
                StatBox(title: "Tasks Completed", value: "\(gameManager.tasks.filter { $0.isCompleted }.count)", icon: "checkmark.circle.fill", color: .green)
                StatBox(title: "Achievements", value: "\(gameManager.achievements.filter { $0.isUnlocked }.count)/\(gameManager.achievements.count)", icon: "trophy.fill", color: .yellow)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct CategoryBreakdownSection: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Breakdown")
                .font(AppFonts.headline())
                .foregroundColor(.primary)

            ForEach(Task.TaskCategory.allCases, id: \.self) { category in
                let categoryTasks = gameManager.tasks.filter { $0.category == category }
                let completedCount = categoryTasks.filter { $0.isCompleted }.count
                let totalCount = categoryTasks.count

                if totalCount > 0 {
                    CategoryProgressRow(
                        category: category,
                        completed: completedCount,
                        total: totalCount
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct CategoryProgressRow: View {
    let category: Task.TaskCategory
    let completed: Int
    let total: Int

    var progress: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .foregroundColor(AppColors.billsBlue)

                Text(category.rawValue)
                    .font(AppFonts.body())
                    .foregroundColor(.primary)

                Spacer()

                Text("\(completed)/\(total)")
                    .font(AppFonts.caption())
                    .foregroundColor(.secondary)
            }

            ProgressView(value: progress)
                .tint(AppColors.billsBlue)
        }
    }
}

struct PlayerPerformanceSection: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Player Performance")
                .font(AppFonts.headline())
                .foregroundColor(.primary)

            ForEach(gameManager.players) { player in
                PlayerPerformanceRow(player: player)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct PlayerPerformanceRow: View {
    let player: Player

    var body: some View {
        HStack {
            Text(player.avatarName)
                .font(.system(size: 40))

            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(AppFonts.body())
                    .foregroundColor(.primary)

                HStack(spacing: 16) {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("\(player.stats.totalPoints) pts")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("\(player.stats.currentStreak) day")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text("\(player.stats.tasksCompleted)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TrendsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Trends")
                .font(AppFonts.headline())
                .foregroundColor(.primary)

            // Placeholder for future chart implementation
            VStack {
                Text("📊")
                    .font(.system(size: 60))
                Text("Charts coming soon!")
                    .font(AppFonts.body())
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}
