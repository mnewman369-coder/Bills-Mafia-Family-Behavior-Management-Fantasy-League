import SwiftUI

// MARK: - Rival Team Data Model

struct RivalTeam: Identifiable {
    let id: UUID
    var teamName: String
    var avatarName: String
    var totalPoints: Int
    var currentStreak: Int
    var wins: Int
    var losses: Int
    var lastMatchResult: MatchResult?

    enum MatchResult {
        case won
        case lost
        case tie
    }

    init(id: UUID = UUID(), teamName: String, avatarName: String, totalPoints: Int, currentStreak: Int, wins: Int = 0, losses: Int = 0) {
        self.id = id
        self.teamName = teamName
        self.avatarName = avatarName
        self.totalPoints = totalPoints
        self.currentStreak = currentStreak
        self.wins = wins
        self.losses = losses
        self.lastMatchResult = nil
    }
}

// MARK: - Rivals View

struct RivalsView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var rivalTeams: [RivalTeam] = [
        RivalTeam(teamName: "Garcia Gang", avatarName: "👨‍👩‍👧‍👦", totalPoints: 3124, currentStreak: 12, wins: 8, losses: 2),
        RivalTeam(teamName: "Smith Squad", avatarName: "🦸‍♂️", totalPoints: 2956, currentStreak: 10, wins: 7, losses: 3),
        RivalTeam(teamName: "Johnson Crew", avatarName: "🏠", totalPoints: 2789, currentStreak: 5, wins: 6, losses: 4),
        RivalTeam(teamName: "Rodriguez Family", avatarName: "⚡", totalPoints: 2654, currentStreak: 8, wins: 5, losses: 5)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Your Team Card
                    YourTeamStandingCard()

                    // Division Header
                    Text("Division Rivals")
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Rival Teams
                    ForEach(Array(rivalTeams.enumerated()), id: \.element.id) { index, rival in
                        RivalTeamCard(rival: rival, rank: index + 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Rivals")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct YourTeamStandingCard: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(spacing: 0) {
            // Rank Badge
            HStack {
                Spacer()
                Text("#1")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        LinearGradient(
                            colors: [AppColors.gold, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5)
                    .offset(y: 20)
                Spacer()
            }

            VStack(spacing: 16) {
                // Team Header
                HStack(spacing: 16) {
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
                }
                .padding(.top, 30)

                Divider()

                // Stats Grid
                HStack(spacing: 0) {
                    StatColumn(title: "Points", value: "\(gameManager.totalPoints)", color: AppColors.billsBlue)
                    Divider().frame(height: 40)
                    StatColumn(title: "Players", value: "\(gameManager.players.count)", color: AppColors.billsBlue)
                    Divider().frame(height: 40)
                    StatColumn(title: "Achievements", value: "\(gameManager.achievements.filter { $0.isUnlocked }.count)", color: AppColors.billsBlue)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: AppColors.gold.opacity(0.3), radius: 10)
        }
    }
}

struct RivalTeamCard: View {
    let rival: RivalTeam
    let rank: Int

    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(rank)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .frame(width: 40)

            // Avatar
            Text(rival.avatarName)
                .font(.system(size: 40))

            // Team Info
            VStack(alignment: .leading, spacing: 4) {
                Text(rival.teamName)
                    .font(AppFonts.body())
                    .foregroundColor(.primary)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                        Text("\(rival.totalPoints)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                        Text("\(rival.currentStreak)")
                            .font(AppFonts.caption())
                            .foregroundColor(.secondary)
                    }

                    Text("\(rival.wins)-\(rival.losses)")
                        .font(AppFonts.caption())
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Challenge Button
            Button(action: {}) {
                Text("Challenge")
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.billsBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.billsBlue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct StatColumn: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)

            Text(title)
                .font(AppFonts.caption())
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - More Menu View

struct MoreMenuView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showingTeamCustomization = false

    var body: some View {
        NavigationView {
            List {
                Section("Team") {
                    Button(action: { showingTeamCustomization = true }) {
                        MenuRow(icon: "pencil.circle.fill", title: "Customize Team", color: AppColors.billsBlue)
                    }

                    NavigationLink(destination: RivalsView()) {
                        MenuRow(icon: "person.2.fill", title: "Rivals", color: AppColors.billsRed)
                    }

                    NavigationLink(destination: StatisticsDashboardView()) {
                        MenuRow(icon: "chart.bar.fill", title: "Statistics", color: .purple)
                    }
                }

                Section("Gameplay") {
                    NavigationLink(destination: WeeklyChallengesView()) {
                        MenuRow(icon: "target", title: "Weekly Challenges", color: .orange)
                    }

                    NavigationLink(destination: PlaybookView()) {
                        MenuRow(icon: "book.fill", title: "Playbook", color: .green)
                    }
                }

                Section("Settings") {
                    NavigationLink(destination: NotificationsSettingsView()) {
                        MenuRow(icon: "bell.fill", title: "Notifications", color: .blue)
                    }

                    NavigationLink(destination: AboutView()) {
                        MenuRow(icon: "info.circle.fill", title: "About", color: .gray)
                    }
                }

                Section("Support") {
                    Button(action: {}) {
                        MenuRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .cyan)
                    }

                    Button(action: {}) {
                        MenuRow(icon: "star.fill", title: "Rate App", color: .yellow)
                    }
                }
            }
            .navigationTitle("More")
            .sheet(isPresented: $showingTeamCustomization) {
                TeamCustomizationView()
            }
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)

            Text(title)
                .font(AppFonts.body())
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Settings Views

struct NotificationsSettingsView: View {
    @State private var dailyReminders = true
    @State private var achievementAlerts = true
    @State private var weeklyReports = true
    @State private var socialUpdates = true

    var body: some View {
        Form {
            Section("Reminders") {
                Toggle("Daily Task Reminders", isOn: $dailyReminders)
                Toggle("Achievement Alerts", isOn: $achievementAlerts)
                Toggle("Weekly Reports", isOn: $weeklyReports)
            }

            Section("Social") {
                Toggle("Community Updates", isOn: $socialUpdates)
            }
        }
        .navigationTitle("Notifications")
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon
                Text("🦬")
                    .font(.system(size: 100))

                Text("Newman Fantasy Football")
                    .font(AppFonts.title())
                    .foregroundColor(AppColors.billsBlue)

                Text("Version 1.0.0")
                    .font(AppFonts.caption())
                    .foregroundColor(.secondary)

                Divider()

                // Mission Statement
                VStack(alignment: .leading, spacing: 16) {
                    Text("Our Mission")
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    Text("Building stronger families through gamified behavior management and positive reinforcement. Inspired by the passion of Bills Mafia and designed for families who want to build lasting legacies.")
                        .font(AppFonts.body())
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Divider()

                // Credits
                VStack(alignment: .leading, spacing: 16) {
                    Text("Built For")
                        .font(AppFonts.headline())
                        .foregroundColor(.primary)

                    Text("Jack and Lillie Newman\nThe future leaders of Newman Nation 🦬")
                        .font(AppFonts.body())
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("About")
    }
}
