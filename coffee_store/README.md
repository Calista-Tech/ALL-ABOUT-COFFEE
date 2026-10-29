# All About Coffee

All About Coffee is a Flutter coffee ordering app for browsing products, customizing brews, managing favorites, and completing pickup or delivery checkout through Xendit payments. Products are synchronized with Supabase in realtime, with the bundled coffee catalog available as an offline starting point.

## Features

- Product catalog with search and category filters
- Espresso and cold-brew categories
- Coffee detail views with cup size, sugar level, and quantity controls
- Saved/favorite brews with customizable recipes
- Shopping bag with quantity controls, pickup/delivery selection, and price totals
- Guest-style checkout with customer details and delivery address fields
- Xendit invoice payments through an in-app Android/iOS WebView
- External payment-page fallback on web and unsupported platforms
- Supabase product realtime updates
- Supabase order-status polling after payment
- Local notification list with read and dismiss actions
- Responsive layouts for mobile-sized screens

## Tech Stack

- Flutter and Dart
- Material 3
- Supabase Flutter
- Supabase Realtime and Edge Functions
- Supabase `products` and `orders` data
- Xendit invoicing
- `webview_flutter`
- `url_launcher`
- HTTP package support

## Project Structure

```text
lib/
├── main.dart                 App entry point and Supabase initialization
├── config/                   Supabase application configuration
├── core/                     Shared colors and theme constants
├── data/                     Local coffee and notification seed data
├── models/                   Coffee, cart, and notification models
├── services/                 Supabase products, payment, and checkout flow
├── screens/                 Splash, catalog, cart, checkout, success, and guest UI
└── widgets/                  Shared headers, cards, navigation, and image widgets
assets/
└── images/                   Bundled logo, background, and coffee photos
```

## Requirements

- Flutter SDK 3.47 or newer
- Dart SDK 3.12 or newer
- A Supabase project
- A deployed Supabase Edge Function named `create-invoice`
- Xendit test or production credentials configured in the backend function
- Android Studio or Xcode for platform device builds

## Setup

1. Clone the repository and enter the app directory:

```powershell
cd c:\coffee_shop\coffee_store
flutter pub get
```

2. Make sure the dependencies in `pubspec.yaml` match the Flutter SDK and assets are included:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

3. Configure Supabase and Xendit in the project's backend and client configuration.

The app currently initializes Supabase in `lib/main.dart` through values exposed by `lib/config/app_config.dart`. Replace these values with your own project credentials when moving away from the included project:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

Use the Supabase publishable/anon key in the client. Never put your Xendit secret key, service-role key, or webhook signing secret in this Flutter app.

## Supabase Backend

The app expects the following backend resources:

### `products` table

Used by the realtime product stream.

Expected fields include:

| Field | Purpose |
|---|---|
| `id` | Product primary key |
| `created_at` | Stream ordering |
| `name` | Product name |
| `short_desc` | Short description |
| `tag` | Product label/category |
| `price` | Numeric price |
| `rating` | Product rating |
| `reviews` | Review count |
| `image_url` | Bundled asset path or public image URL |
| `info` | Product information |
| `category` | `espresso` or `cold_brew` |
| `is_active` | Whether the product is visible |

Enable the related Supabase Realtime stream and ensure the app's anon role has the required table access policies.

### `orders` table

Used for order-status lookup and polling. The checkout flow expects an `external_id` column and a `status` column. Status is checked for `PAID`; another status prevents the success screen from opening.

Rows should be created or updated by the backend after invoice creation and after Xendit payment webhook verification.

### `create-invoice` Edge Function

The app sends a function request containing:

```text
product_name
amount
customer_name
phone
address
order_type
items
```

The function must return:

```json
{
  "invoice_url": "https://...",
  "external_id": "..."
}
```

On failure, return an `error` field. Keep secret Xendit credentials on the server, and use a webhook or server-side callback to mark orders as `PAID`.

## Running the App

Run on a connected device or emulator:

```powershell
flutter run
```

Run a specific platform:

```powershell
flutter run -d windows
flutter run -d chrome
flutter run -d android
```

Start on an Android emulator or iOS simulator with Supabase network access enabled.

The secure Xendit payment WebView is implemented for Android and iOS. Web and desktop builds use an external payment-page link instead.

## Validation

Analyze the project:

```powershell
flutter analyze
```

Run Flutter tests:

```powershell
flutter test
```

## Assets

All image assets are loaded from `assets/images/`. The app currently includes:

- `logo.png`
- `beans_bg.png`
- `americano.jpg`
- `caramel_macchiato.jpg`
- `caffe_mocha.jpg`
- `flat_white.jpg`
- `con_panna.jpg`
- `pumpkin_cream_cold_brew.jpg`
- `chocolate_cream_cold_brew.jpg`
- `cinnamon_caramel_cold_brew.jpg`
- `coconut_milk_cold_brew.jpg`
- `irish_cream_cold_brew.jpg`

Missing images show a coffee placeholder icon through the shared `AppImage` widget. Remote HTTPS image URLs returned by Supabase are also supported.

## Data and State Behavior

- Cart, favorites, and custom recipes are currently in-memory state owned by the main app shell and are cleared when the app restarts.
- The notification list is local seed data and supports read, delete, and mark-all-read actions.
- Local coffee seed data starts the catalog before the Supabase realtime stream replaces it.
- Payment completion is confirmed by polling the Supabase `orders` table for a `PAID` status.
- Checkout waits up to approximately six seconds for late webhook status updates.

## Current Package Identity

The `pubspec.yaml` package name is currently `myapp`, while source imports use `package:coffee_store/main.dart`. For consistency, rename the package entry in configuration when creating a production package identity.
