# Photo Editor App

A simple photo editor app built with **SwiftUI** that allows users to log in and register via **Firebase**. The app enables users to **edit photos** by **drawing**, **rotating**, and **applying filters**.

## Features

- **User Authentication**:
  - Register and log in using **Google account**.
  - Email and password-based login/registration.
  - Email verification for new users.
  
- **Photo Editing**:
  - **Draw** on images using PencilKit.
  - **Rotate** images with adjustable degrees.
  - **Apply Filters** to enhance images.
  
- **Image Export**:
  - Export the edited image to share it with others.

## Prerequisites

- **Xcode 13** or later
- **Firebase project setup** (with Firebase Authentication enabled)

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/ShadowPlayer34/PhotoEditor.git
   cd photo-editor-app
2. Open the project in Xcode. The necessary Firebase SDK dependencies will be automatically downloaded via Swift Package Manager as soon as you open the project.

3. Set up Firebase in your project:

   - Create a Firebase project at Firebase Console.
   - Add your GoogleService-Info.plist file to the project.
   - Enable Firebase Authentication (Email/Password) in the Firebase console.
4. Open the .xcodeproj file in Xcode and run the app on a simulator or real device.

## Usage
 1. Login/Registration:
    - Open the app and either log in or register a new account using your email and password.
    - After successful registration, Firebase will send a verification email to the provided email address.
      
 2. Editing Images:
    - Choose a photo from your library or take a picture with your camera.
    - Draw on the image with PencilKit (use your finger or Apple Pencil).
    - Use the rotate feature to rotate the image by a specific degree.
    - Apply filters from a list of available filters to adjust the image.
      
 3. Exporting the Image:
    - Once you're done editing the image, you can export it and share it via the system share sheet.
      
## Architecture
This app follows the MVVM (Model-View-ViewModel) architecture, which separates concerns and promotes code reusability and testability.

### Key Components
  - Model: Contains the data used in the app, including the image being edited and any transformations applied (e.g., filters, rotation).

  - View: Built using SwiftUI components, presenting the user interface, including buttons for logging in, drawing on images, rotating, and applying filters.

  - ViewModel: Acts as a bridge between the view and model, managing state (like whether the user is logged in), image transformations, and interactions with Firebase.

### Firebase Authentication
  - Login and Registration are handled through Firebase's built-in authentication system. This includes email/password login, user registration, and email verification.

### Photo Editing
  - Drawing is handled using PencilKit, which allows users to freely draw on images.
  - Rotating is implemented by transforming the image's CGImage through a rotation matrix.
  - Filters are applied using CoreImage, which provides a wide range of image filtering options.
    
## Contributing
  - Fork the repository.
  - Create a new branch for your feature or bug fix.
  - Make your changes and test them.
  - Submit a pull request with a description of your changes.
