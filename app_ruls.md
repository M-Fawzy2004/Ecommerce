# REHLATAK APP — Engineering & Design Standards

> Every rule here is binding. When in doubt, follow this file strictly.

---

## 1. Project Architecture

The project is a **strict Clean Architecture** Flutter app.
Everything shared across features lives in `core/`. Everything feature-specific is isolated inside `features/[name]/`.

```
lib/
├── core/
│   ├── constants/        → app_constants.dart (API endpoints, timeouts)
│   ├── di/               → injection_container.dart (GetIt)
│   ├── network/          → api_client.dart, network_info.dart (Dio)
│   ├── routes/           → app_router.dart (GoRouter — single source)
│   ├── theme/            → app_colors.dart, app_text_styles.dart, app_theme.dart
│   ├── ui/               → app_spacing.dart, app_radius.dart, app_font_weights.dart
│   │   └── toast/        → app_toast.dart (all user feedback)
│   ├── utils/            → assets.dart (generated asset paths)
│   └── widgets/          → app_button.dart, app_back_button.dart, fade_in_slide.dart
└── features/
    └── [feature]/
        ├── data/          → models/, datasources/, repo_impl
        ├── domain/        → entities/, usecases/, repo interfaces
        └── presentation/
            ├── cubit/     → [feature]_cubit.dart, [feature]_state.dart
            ├── pages/     → [feature]_page.dart, [feature]_page_body.dart
            └── widgets/   → feature-specific UI components
```

---

## 2. Presentation Layer — MANDATORY Page/Body Pattern

Every screen **must** be split into exactly two files:

| File | Responsibility |
|---|---|
| `[feature]_page.dart` | `Scaffold` + `BlocProvider` + route target only |
| `[feature]_page_body.dart` | All UI, layout, and widget composition |

**Rules:**
- `Page` must NOT contain any layout widgets (no `Column`, `Row`, `Container`).
- `PageBody` `build()` must **not exceed 60 lines**. Extract sub-components to `widgets/`.
- Name private widgets descriptively: `_PhoneSection`, `_WelcomeHeader`.

```dart
// ✅ CORRECT
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const Scaffold(
        backgroundColor: AppColors.backgroundSoft,
        body: LoginPageBody(),
      ),
    );
  }
}
```

---

## 3. Design System — No Hardcoded Values

Using raw numbers is **forbidden**. Use only the tokens below.

### Spacing → `AppSpacing` / `VerticalSpace` / `HorizontalSpace`
```dart
// ✅
AppSpacing.h24
AppSpacing.w16
VerticalSpace(40)   // dynamic
HorizontalSpace(12) // dynamic

// ❌ FORBIDDEN
SizedBox(height: 24)
SizedBox(height: 24.0)
```

### Radius → `AppRadius`
```dart
// ✅
AppRadius.r12        // BorderRadius.circular(12.r)
AppRadius.r16
AppRadius.all12      // BorderRadius.all(Radius.circular(12.r))

// ❌ FORBIDDEN
BorderRadius.circular(12)
```

### Responsiveness → `flutter_screenutil`
```dart
// ✅ All dimensions must use screenutil extensions
width: 100.w,  height: 48.h,  fontSize: 16.sp,  radius: 12.r

// ❌ FORBIDDEN
width: 100,  fontSize: 16
```

### Colors → `AppColors`
```dart
// ✅
AppColors.primaryBlue
AppColors.textPrimary
AppColors.backgroundSoft

// ❌ FORBIDDEN
Color(0xFF095380)
Colors.grey
```

### Typography → `AppTextStyles`
```dart
// ✅
AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimary)
AppTextStyles.bodyMedium

// ❌ FORBIDDEN
TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
```

---

## 4. Global Widgets (`core/widgets/`)

| Widget | Usage |
|---|---|
| `AppButton` | All primary action buttons with loading state |
| `AppBackButton` | All back navigation |
| `FadeInSlide` | Reusable entry animation (splash, onboarding, etc.) |

**Rule:** Before creating any new widget in a feature, check if it should live in `core/widgets/` instead (i.e., is it used in >1 feature?).

---

## 5. State Management

- Use **Cubit** for simple UI state.
- Use **Bloc** only for complex event-driven flows.
- State classes must extend `Equatable`.
- States live in a `part` file: `[feature]_state.dart`.

```dart
// ✅ State pattern
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}
class AuthLoading extends AuthState { const AuthLoading(); }
class AuthOtpSent extends AuthState { const AuthOtpSent(); }
```

---

## 6. Localization

**Rule:** Hardcoding any UI string is strictly forbidden.

```dart
// ✅
Text('auth.welcome_title'.tr())

// ❌ FORBIDDEN
Text('Welcome to Rehlatak')
```

All keys must exist in both `assets/translations/en.json` and `assets/translations/ar.json`.

---

## 7. Navigation

- All routes are defined in `core/routes/app_router.dart`.
- Use **named constants** for route paths.
- Navigate using `context.go()` or `context.push()` from `go_router`.

```dart
// ✅
context.go(AppRouter.login)

// ❌ FORBIDDEN
Navigator.pushNamed(context, '/login')
```

---

## 8. Assets

Always use the generated `Assets` class from `core/utils/assets.dart`.

```dart
// ✅
Image.asset(Assets.imagesPngLogoApp)

// ❌ FORBIDDEN
Image.asset('assets/images/png/logo_app.png')
```

---

## 9. File Length Rule

| File Type | Max Lines |
|---|---|
| `_page.dart` | 40 lines |
| `_page_body.dart` | 120 lines |
| `_cubit.dart` | 80 lines |
| `_state.dart` | 80 lines |
| Widget file | 150 lines |
| Any other file | 300 lines |

If you exceed these limits, **split the file**.

---

## 10. User Feedback

Always use `AppToast` for success/error feedback. Never use `ScaffoldMessenger` directly.

```dart
// ✅
AppToast.success(context, message: 'auth.success'.tr());
AppToast.error(context, message: 'error_generic'.tr());
```