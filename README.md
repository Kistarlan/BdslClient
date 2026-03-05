# BDSL Client (Bachata Dance School Lviv)

BDSL Client is an iOS application built for the community of Bachata Dance School Lviv (BDSL).  
The app enables students to stay up to date with the latest schedule, manage their subscriptions,  
review subscription history, and maintain their personal profile.

## Features
- View the latest and upcoming class schedule
- See active subscriptions (passes) and their details
- Browse subscription history
- Manage and view user profile information

## Requirements
- Xcode 15 or later
- iOS 18.6 or later (deployment target may vary based on project settings)
- Swift 6+

## Getting Started

### 1. Clone the repository

git clone <your-repo-url>
cd <repo-folder>

### 2. Generate the Config file

The app requires a Config.swift file to be present in the project. This file contains configuration
values such as API base URL, deep link scheme, and token storage service name.

Create a file at BdslClient/Config.swift (or the appropriate target folder)

Note: If Config.swift is excluded from source control (e.g., via .gitignore), ensure each developer
creates this file locally before building the project. You may also keep a Config.example.swift as a
template and instruct developers to copy it to Config.swift.

### 3. Open the project in Xcode and build
	-	Open the .xcodeproj or .xcworkspace in Xcode
	-	Select a simulator or device
	-	Build and run (Cmd+R)

## Contributing

Contributions are welcome! Please open an issue to discuss proposed changes or submit a pull request.

## License

This project is distributed under the BDSL Client Proprietary License.  
See the full text in [LICENSE.md](./LICENSE.md).

## Contact

For questions or support related to the BDSL app, please contact the Bachata Dance School Lviv administration or the app maintainers.

Code Style & Formatting

This project uses SwiftFormat to enforce a consistent Swift code style.
	-	Install: brew install swiftformat
	-	Format code locally: swiftformat .
	-	Configuration is defined in .swiftformat at the repository root.
	-	CI and/or local hooks may use SwiftFormat to ensure consistent formatting across contributions.

