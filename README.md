# FitCounter 💪

An iOS app that counts exercise repetitions in real-time using CoreML and Vision framework.

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue?logo=apple)
![Xcode](https://img.shields.io/badge/Xcode-16.0+-147EFB?logo=xcode)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-purple)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

FitCounter uses your iPhone's front camera to detect body pose in real-time and automatically counts exercise repetitions — no wearable required.

## Features

- 🎥 **Real-time pose detection** via Vision framework
- 🤖 **CoreML model** trained with Create ML
- 📊 **Rep counter** with confidence scoring
- ⏱️ **Session tracking** with duration and statistics
- 🏋️ **Supported exercises**: Squat, Push-up, Sit-up
- 📅 **Workout history** with SwiftData persistence
- 🦴 **Skeleton overlay** rendered with SwiftUI Canvas

## Screenshots

> Coming soon — real device required for camera features

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | SwiftUI |
| Architecture | MVVM |
| Camera | AVFoundation |
| Pose Detection | Vision |
| ML Model | CoreML + Create ML |
| Reactive | Combine |
| Persistence | SwiftData |

## Project Structure
```
FitCounter/
├── Models/
│   ├── ExerciseSession.swift    # Session data model
│   └── WorkoutRecord.swift      # SwiftData persistent model
├── ViewModels/
│   └── WorkoutViewModel.swift   # Business logic + bindings
├── Views/
│   ├── ContentView.swift        # Main screen
│   ├── CameraPreviewView.swift  # AVFoundation bridge
│   ├── RepCounterView.swift     # Rep counter UI
│   ├── SkeletonOverlayView.swift # Canvas skeleton drawing
│   ├── ExerciseSelectionView.swift # Exercise picker sheet
│   └── HistoryView.swift        # Workout history screen
├── Services/
│   ├── CameraService.swift      # AVFoundation + Combine
│   └── PoseDetectionService.swift # Vision framework
└── Utilities/
    └── Extensions.swift
```

## How It Works

1. **Camera** — AVFoundation streams live frames via Combine publisher
2. **Pose Detection** — Vision detects 19 body joint points per frame
3. **Angle Analysis** — Key joint angles calculated for each exercise
4. **Rep Counting** — State machine detects down→up movement cycles
5. **Persistence** — Completed sessions saved to SwiftData store

## Roadmap

- [x] MVVM architecture setup
- [x] Camera integration with AVFoundation
- [x] Pose detection with Vision framework
- [x] Skeleton overlay with SwiftUI Canvas
- [x] Rep counting algorithm with state machine
- [x] Exercise selection (squat, push-up, sit-up)
- [x] SwiftData persistence
- [x] Workout history screen
- [ ] CoreML custom model training with Create ML
- [ ] Apple Watch companion app
- [ ] App Store release

## Requirements

- iOS 17.0+
- Xcode 16.0+
- Physical device recommended (camera required)

## Getting Started
```bash
git clone https://github.com/52BaranHaydar/FitCounter.git
cd FitCounter
open FitCounter.xcodeproj
```

Then select your device and press `Cmd+R`.

## Author

**Baran Haydar** — Computer Engineering Student
GitHub: [@52BaranHaydar](https://github.com/52BaranHaydar)

## License

MIT License — see [LICENSE](LICENSE) for details.
