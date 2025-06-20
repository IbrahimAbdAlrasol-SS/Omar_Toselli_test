# Providers Structure

This directory contains all the application providers organized by feature.

## Directory Structure

```
core/providers/
├── auth/
│   ├── auth_provider.dart
│   ├── pending_activation_provider.dart
│   └── registration_provider.dart
├── home/
│   └── home_provider.dart
├── order/
│   ├── orders_provider.dart
│   ├── shipments_provider.dart
│   └── order_commands_provider.dart
├── profile/
│   ├── profile_provider.dart
│   ├── zone_provider.dart
│   └── transaction_provider.dart
└── README.md
```

## Provider Categories

### Authentication Providers (`auth/`)
- **auth_provider.dart**: Handles user authentication, login, logout
- **pending_activation_provider.dart**: Manages account activation process
- **registration_provider.dart**: Handles user registration and brand setup

### Home Providers (`home/`)
- **home_provider.dart**: Manages home screen data and state

### Order Providers (`order/`)
- **orders_provider.dart**: Manages order listing, searching, and validation
- **shipments_provider.dart**: Handles shipment creation and management
- **order_commands_provider.dart**: Manages order state changes and commands

### Profile Providers (`profile/`)
- **profile_provider.dart**: Handles user profile updates and password changes
- **zone_provider.dart**: Manages zones and governorates
- **transaction_provider.dart**: Handles transaction history

## Migration Notes

All providers have been moved from their original locations in `Features/` to this centralized structure for better organization and maintainability.

### Import Path Changes

When updating imports in your screens and widgets, change from:
```dart
// Old imports
import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/Features/order/orders/providers/orders_provider.dart';
```

To:
```dart
// New imports
import 'package:Tosell/core/providers/auth/auth_provider.dart';
import 'package:Tosell/core/providers/order/orders_provider.dart';
```