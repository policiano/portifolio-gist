# Gist

[![Swift 5.0](https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat)](https://swift.org)
![Platform iOS](https://img.shields.io/badge/platform-iOS%2014-inactive)
![Xcode](https://img.shields.io/badge/IDE-Xcode%2012.3-blue)
[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)

A simple Gist app using the Clean Architecture.

![iPad-gif](https://user-images.githubusercontent.com/2760956/89153164-c2214080-d53a-11ea-8f00-73b8c401449d.gif)

## Features

- List the latest public gists
- Search and bookmark them
- See more details of the gist and its snippets
- Access your bookmarks offline

## Non-functional features

- Clean Architecture
- Modular projects with Tuist
- MVP
- Unit Tests using TDD
- Exploring Cupertino Design
- Dynamic Text
- Size Classes/ Universal Apps
- Dynamic Theme (Native Dark Mode)
- Webview Javascript/HTML injection
- Local Persistence
- HTTP requests
- Error Handling
- Localization
- Combine

## Universal app

It supports multple orientations!

### Dark mode ready

![iPhone-gif](https://user-images.githubusercontent.com/2760956/89153148-bd5c8c80-d53a-11ea-88f1-e64d405d60b8.gif)

## Dynamic Text

Ready for people with low sight

![DynamicText-gif](https://user-images.githubusercontent.com/2760956/89153169-c3eb0400-d53a-11ea-9084-ec33de2dea85.gif)


## Instalation

1. Clone or download the repository
3. Go to repository folder:
```
cd Gist
```
4. Execute the setup script:
```
make initial_setup
```

**Or...**

1. Clone or download the repository
2. Install Tuist tool:
```bash
bash <(curl -Ls https://install.tuist.io)
```
3. Go to repository folder
4. Set the environment up
```bash
tuist up
```
5. Generate the workspace
```bash
tuist clean && tuist generate
```
6. And open the project
```
open Gist.xcworkspace
```
