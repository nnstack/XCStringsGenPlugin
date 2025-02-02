# XCStringsGenPlugin

[![Swift Version](https://img.shields.io/badge/swift-6.0-0f73b4.svg)](https://swift.org)
[![License](https://img.shields.io/github/license/nonasim/XCStringsGenPlugin)](https://github.com/nonasim/XCStringsGenPlugin/blob/main/LICENSE)

**XCStringsGenPlugin** is a lightweight yet powerful tool designed to automate the generation and maintenance of type-safe user-facing strings from String Catalog(s). Seamlessly integrating into your Xcode workflow, this plugin saves time, reduces errors, and ensures consistency across your localization files.

> [!NOTE]
> This repository contains the source code for XCStringsGen. It's designed for developers who need to customize or extend the functionality.
> Please consider using the [binary version](https://github.com/nonasim/XCStringsGenProPlugin) to avoid compilation, reduce build times, and simplify dependencies.

## Motivation

Localization using String Catalogs should be seamless, not a source of friction. This tool simplifies working with string catalogs while using familiar terminologies, eliminating the need for additional learning. With a type-safe approach, accessing localized strings becomes intuitive, reducing errors and improving maintainability. Say goodbye to hardcoded keys and manual string management—this tool ensures a smoother, more efficient localization workflow.

## Installation

### Option 1: Integrating into your Xcode project

1. Open your project in Xcode.
2. Go to **File** → **Add Package Dependencies...**
3. Enter the package URL: `https://github.com/nonasim/XCStringsGenPlugin.git` and set the dependency rule.
<img width="900" src="https://github.com/user-attachments/assets/48390fef-224f-411a-92df-97f6b7439449" />

5. Click **Add Package** and select the appropriate target.
6. Add it as a Build Tool Plug-in:
    1. Select appropriate target -> Build Phases
    2. Expand **Run Build Tool Plug-ins** and use **+** button to add XCStringsGenPlugin
<img width="900" src="https://github.com/user-attachments/assets/20d03f70-4803-4bc0-9eaa-22658867840e" />


### Option 2: Integrating into your Swift package

1. Open `Package.swift` file
2. Add it as package dependency:
```swift
dependencies: [
 .package(url: "https://github.com/nonasim/XCStringsGenPlugin.git", from: "1.0.0"),
],
```
3. Add as build tool plugin for the target:
```swift
.target(
    name: "AppCore",
    ...
    plugins: [
        .plugin(name: "XCStringsGenPlugin", package: "XCStringsGenPlugin"),
    ]
)
```

## Usage

When building the project for the first time after adding the plugin, you may encounter a build error stating "XCStringsGenPlugin" is disabled. To proceed, click the error in the Issue Navigator, review the plugin, enable the plugin and then build again.
<img width="900" src="https://github.com/user-attachments/assets/d5954226-06d9-4b7f-9448-d9402f1890b8" />

Once the build process is complete, you should be able to see the file path through **Report navigator** under **Run custom shell script 'XCStringsGen: Code generation'**. This tells you that the file has been generated and its attributes can be referenced from the code.

In case you want to take a look at the file, you can open it through the file path above OR you can jump to the file from any reference from code using options like **Command(⌘) + Click** since this is compiled as part of the target.

Based on the entries in your String Catalog, the plugin generates a localized `L10n` enum which you can access as follows:
```swift
struct ContentView: View {
    @State private var username: String = "Alice"
    @State private var notificationCount: Int = 5
    @State private var balance: Double = 1234.56
    
    var body: some View {
        VStack {
            // Welcome to the app!
            Text(L10n.welcomeMessage)
            
            // Hello, %@! We're glad to see you.
            Text(L10n.greetings(username))
            
            // You have %d new notifications.
            Text(L10n.notificationMessage(notificationCount))
            
            // %@, you have %d unread messages and your account balance is $%.2f.
            Text(L10n.summary(username, notificationCount, balance))
        }
        .padding()
    }
}
```

The plugin also supports multiple String Catalogs. If you have two or more String Catalogs then the filename is used as a namespace. This is how that looks:
```swift
Text(L10n.Onboarding.greetings(username))
Text(L10n.Settings.generalNote)
```

## Contributing

Contributions are welcome. To contribute, please follow these steps:

1. Create a new branch (`git checkout -b feature/{my-feature}`).
2. Make your changes and write tests to cover new functionality.
3. Commit your changes.
4. Push to the branch (`git push origin feature/{my-feature}`).
5. Open a pull request.

### Guidelines

- Ensure all code follows Swift's [style guide](https://swift.org/documentation/#the-swift-programming-language).
- Write clear and concise commit messages.
- If your changes introduce new functionality, please include tests for it.
- Please ensure that all existing tests pass.

---

If you find **XCStringsGenPlugin** useful, please consider starring the repository ⭐ to help it reach more developers. If you have any questions or suggestions, feel free to open an issue!

