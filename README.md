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
│   └── ExerciseSession.swift
├── ViewModels/
│   └── WorkoutViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── CameraPreviewView.swift
│   └── RepCounterView.swift
├── Services/
│   ├── CameraService.swift
│   └── PoseDetectionService.swift
└── Utilities/
    └── Extensions.swift
```

## Roadmap

- [x] MVVM architecture setup
- [x] Camera integration with AVFoundation
- [ ] Pose detection with Vision framework
- [ ] CoreML model training with Create ML
- [ ] Rep counting algorithm
- [ ] SwiftData persistence
- [ ] Statistics screen

## Requirements

- iOS 17.0+
- Xcode 16.0+
- Physical device recommended (camera required)

## Author

**Baran Haydar** — Computer Engineering Student
GitHub: [@52BaranHaydar](https://github.com/52BaranHaydar)

## License

MIT License — see [LICENSE](LICENSE) for details.
