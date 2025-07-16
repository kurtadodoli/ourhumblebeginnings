# Copilot Instructions for Our Humble Beginnings

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
This is a Flutter mobile application for "Our Humble Beginnings" - a cafe/giftshop with room reservation functionality for meetings, family gatherings, and work sessions.

## Architecture Guidelines
- Use Flutter best practices and Material Design principles
- Implement clean architecture with proper separation of concerns
- Use state management (Provider, Riverpod, or Bloc)
- Follow Dart naming conventions and documentation standards
- Ensure cross-platform compatibility (Android and iOS)

## Key Features
1. **Cafe/Giftshop Management**
   - Product catalog browsing
   - Menu display
   - Order management
   - Gift shop items

2. **Room Reservation System**
   - Available rooms display
   - Booking calendar
   - Reservation management
   - User authentication

3. **User Experience**
   - Intuitive navigation
   - Responsive design
   - Offline capability considerations
   - Accessibility features

## Code Style
- Use meaningful variable and function names
- Add comprehensive comments for complex logic
- Implement proper error handling
- Follow Flutter/Dart linting rules
- Use async/await for asynchronous operations

## Dependencies to Consider
- `provider` or `riverpod` for state management
- `http` or `dio` for API calls
- `shared_preferences` for local storage
- `table_calendar` for reservation calendar
- `image_picker` for user uploads
- `flutter_local_notifications` for notifications
