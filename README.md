# SpaceX App - Applifting iOS task
This project has been developed entirely from scratch and solely by Jan Růžička as a skillset demonstration in the field of iOS development.

It is an iOS application written in Swift and UIKit that connects to open-source SpaceX API, fetches data from it, and displays it to the user.

## 📱 Features
The app presents all past SpaceX rocket launches. There are 2 separate screens for that. One shows all the launches in a table format while the other is used to show more detailed information about a particular rocket launch.

When you start the application, you see the list of all past launches. Here you have several presentation configurations available. You can choose the order the launches are shown - either by date ascending or by date descending. This is implemented as an action sheet triggered by a click on the "Order" bar button item in the navigation bar. The sort order setting is persistent. Also, you can search for a specific rocket launch using a search field at the top.

The app is designed to work on iPhones only and it supports both portrait and landscape orientation as well as the dark theme.

## 🏗 Architecture
The app is built using the MVVM-C architecture. There are basically 3 layers: data, view and viewModel (corresponding to the project folder structure).

The data layer contains model classes that represent the domain logic as well as classes and protocols related to data manipulation such as networking. This layer also contains repositories that are responsible for providing data and an interface for data operations. The majority of the data layer should not be used elsewhere (in a different layer). Code from other layers should use repositories to get the desired data.

The view consists of all UI-related code. It includes custom views, cells, UIViewControllers as well as coordinators whose job is to define and encapsulate navigation logic between different screens.

The viewModels layer is what binds the previous 2 layers together. ViewModels use repositories to get the desired data and they then expose it in an observable manner (in this case as Combine publishers) so that the view can subscribe or perform transformations as needed. The view also propagates user events to the viewModel via respective functions exposed by the viewModel.

## 🛠 Tools and frameworks used
- Language - Swift
- UI - UIKit, no storyboards
- Reactive framework - Combine
- REST API communication - Alamofire
- JSON parsing - Codable
- Package management - Swift Package Manager
- IDE - Xcode 14.0
