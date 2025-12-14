# Building the Bills Mafia Family Behavior Management Fantasy League App

This repository contains a complete SwiftUI iOS application for managing family behavior through gamification. The app is Bills Mafia-themed and designed for the Newman family.

## Project Structure

```
Bills-Mafia-Family-Behavior-Management-Fantasy-League/
├── NewmanFantasyFootball/           # Xcode project directory
│   ├── ContentView.swift           # Core data models, GameManager, app entry point
│   ├── Views.swift                 # Home, Roster, Playbook, Achievements views
│   ├── ExtendedFeatures.swift      # Create Player wizard, Weekly Challenges, Statistics
│   ├── RivalsAndNavigation.swift   # Rival Teams, More Menu, Settings
│   ├── SocialFeatures.swift        # Social data models (Leagues, Groups, Posts)
│   ├── CommunityHub.swift          # Social UI (Feed, Leagues, Groups, Profiles)
│   ├── Assets.xcassets/            # App icons and resources
│   └── NewmanFantasyFootball.xcodeproj/ # Xcode project configuration
├── outputs/                         # Original source files (reference)
├── Package.swift                    # Swift Package Manager configuration
└── BUILD.md                         # This file
```

## Requirements

- **macOS** 13.0 or later (for Xcode)
- **Xcode** 15.0 or later
- **iOS** 16.0 or later (deployment target)
- **Swift** 5.9 or later

## Build Methods

### Method 1: Xcode (Recommended)

This is the standard way to build an iOS app on macOS.

1. **Open the project:**
   ```bash
   cd NewmanFantasyFootball
   open NewmanFantasyFootball.xcodeproj
   ```

2. **Select a simulator or device:**
   - Choose a target from the scheme selector (e.g., "iPhone 15 Pro")
   - Or connect a physical iOS device

3. **Build and run:**
   - Press `⌘R` (Command-R)
   - Or click the "Play" button in Xcode
   - Or use the menu: Product → Run

4. **Build for release:**
   ```bash
   xcodebuild -project NewmanFantasyFootball.xcodeproj \
              -scheme NewmanFantasyFootball \
              -configuration Release \
              -destination 'generic/platform=iOS' \
              clean build
   ```

### Method 2: Command Line (macOS only)

Build from terminal using xcodebuild:

```bash
# Build for simulator
xcodebuild -project NewmanFantasyFootball/NewmanFantasyFootball.xcodeproj \
           -scheme NewmanFantasyFootball \
           -sdk iphonesimulator \
           -configuration Debug \
           build

# Run in simulator
xcrun simctl boot "iPhone 15 Pro"  # Boot simulator
xcrun simctl install booted <path-to-app>  # Install app
xcrun simctl launch booted com.newman.fantasy.football  # Launch app
```

### Method 3: Swift Playgrounds (iPad)

For a quick demo on iPad without Xcode:

1. Open **Swift Playgrounds** app on iPad
2. Create a new **App** project
3. Copy the contents of each `.swift` file from `NewmanFantasyFootball/` directory
4. Paste them into separate Swift files in Playgrounds
5. Run the app directly on iPad

## Code Architecture

### Core Components

1. **ContentView.swift** (~312 lines)
   - Data models: `Player`, `Task`, `Achievement`, `WeeklyChallenge`
   - `GameManager`: Observable state manager for game logic
   - App colors and fonts (Bills Mafia theme)
   - App entry point: `@main NewmanFantasyFootballApp`
   - Main tab view navigation

2. **Views.swift** (~501 lines)
   - `HomeView`: Dashboard with quick stats and today's tasks
   - `RosterView`: Team roster management
   - `PlaybookView`: Task list with completion tracking
   - `AchievementsView`: Achievement gallery
   - `TeamCustomizationView`: Customize team name and avatar

3. **ExtendedFeatures.swift** (~523 lines)
   - `CreatePlayerView`: 3-step wizard to add family members
   - `WeeklyChallengesView`: Bonus challenge tracker
   - `StatisticsView`: Comprehensive team and player statistics

4. **RivalsAndNavigation.swift** (~383 lines)
   - `RivalTeamsView`: Head-to-head standings
   - `MoreMenuView`: Settings and navigation hub
   - `SettingsView`: App configuration
   - `AboutView`: Mission statement

5. **SocialFeatures.swift** (~412 lines)
   - Data models for social features
   - `League`, `CommunityGroup`, `SocialPost` models
   - `SocialManager`: Observable state manager for social features
   - Sample data for leagues, groups, posts

6. **CommunityHub.swift** (~847 lines)
   - `CommunityFeedView`: Social feed with posts
   - `LeaguesHubView`: Competitive leagues
   - `GroupsHubView`: Community groups
   - `NotificationsView`: Activity notifications
   - Post creation and engagement features

### Design Patterns

- **MVVM**: Model-View-ViewModel architecture
- **ObservableObject**: Reactive state management with `@Published` properties
- **@EnvironmentObject**: Shared state across views
- **SwiftUI**: 100% native SwiftUI views
- **Codable**: All data models support JSON encoding/decoding

## Features

### 🏠 Core Features
- Team management with customizable name and avatar
- Player roster with 10 football positions
- Task system across 8 categories
- 4-tier achievement system (Bronze → Platinum)
- Weekly challenges with bonus rewards
- Streak tracking and point accumulation

### 🌐 Social Features
- Community feed with 8 post types
- Competitive leagues (public/private)
- Community groups (10 categories)
- Team profiles with follow system
- Notifications center

### 🎨 Bills Mafia Branding
- Bills Blue (#003E8D) and Bills Red (#C60C30)
- Buffalo (🦬) as default team avatar
- "Newman Nation" default team name
- Bills Mafia-themed community groups

## Testing

The app includes sample data for immediate testing:
- 2 sample players (Jack and Lillie Newman)
- 5 sample tasks
- 4 sample achievements
- 2 weekly challenges
- 3 leagues
- 6 community groups
- 5 social posts
- 5 notifications
- 4 rival teams

## Customization

To customize the app for your family:

1. **Update team info** in `GameManager.loadSampleData()`:
   ```swift
   teamName = "Your Family Name"
   teamAvatar = "🏈" // or any emoji
   ```

2. **Modify sample players** to match your family members

3. **Adjust tasks** based on your family's routines and values

4. **Customize achievements** with your own milestones

## Deployment Target

- **Minimum iOS version**: 16.0
- **Supported devices**: iPhone and iPad
- **Orientations**: Portrait (primary), Landscape (supported)

## Bundle Information

- **Bundle ID**: `com.newman.fantasy.football`
- **Display Name**: Bills Mafia Family
- **Version**: 1.0
- **Build**: 1

## Future Enhancements

The codebase is structured for easy addition of:
- Backend integration (Firebase, Supabase, etc.)
- CloudKit syncing across devices
- Push notifications
- Photo/video uploads
- Real-time chat
- In-app purchases
- Parental controls

## Troubleshooting

### Build Errors

**"SwiftUI not found"**
- Ensure you're building on macOS with Xcode
- SwiftUI is only available on Apple platforms

**"No such module 'SwiftUI'"**
- Check that iOS deployment target is 16.0 or later
- Verify Xcode version is 15.0 or later

**"Code signing required"**
- For simulator: No code signing needed
- For device: Configure your development team in project settings

### Runtime Issues

**"Preview failed"**
- Clean build folder: ⌘⇧K (Command-Shift-K)
- Restart Xcode
- Check that all files are included in target membership

**"App crashes on launch"**
- Check console for error messages
- Verify all `@EnvironmentObject` dependencies are provided
- Ensure sample data loads correctly

## Contributing

This app was built for the Newman family but can be adapted for any family. Feel free to:
- Customize the theme and branding
- Add new task categories
- Create additional achievement tiers
- Enhance social features
- Add backend integration

## License

This project is private and built specifically for the Newman family's Bills Mafia Family Behavior Management Fantasy League.

---

**Built with ❤️ for the Newman Nation**

*Let's Go Buffalo!* 🏈🦬
