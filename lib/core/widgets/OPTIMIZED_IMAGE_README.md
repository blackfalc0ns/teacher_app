# OptimizedImage Widget - Usage Guide

## 📋 Overview

The `OptimizedImage` widget provides a unified, production-ready solution for loading images with:

- ✅ Automatic caching
- ✅ Shimmer loading placeholders
- ✅ Error handling with retry
- ✅ Fade-in animations
- ✅ Memory-efficient loading

## 🎯 Why Use OptimizedImage?

**Before (CachedNetworkImage):**

```dart
CachedNetworkImage(
  imageUrl: property.primaryImage,
  fit: BoxFit.cover,
  // ❌ No placeholder
  // ❌ No error handling
  // ❌ No fade animation
)
```

**After (OptimizedImage):**

```dart
OptimizedImage(
  imageUrl: property.primaryImage,
  fit: BoxFit.cover,
  // ✅ Automatic shimmer placeholder
  // ✅ Error widget with icon
  // ✅ Smooth fade-in animation
)
```

## 📦 Available Widgets

### 1. OptimizedImage

Main widget for general image loading.

```dart
OptimizedImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 150,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
)
```

### 2. OptimizedCircularImage

For avatars, logos, and circular images.

```dart
OptimizedCircularImage(
  imageUrl: user.profileImage,
  size: 50,
)
```

### 3. OptimizedAspectRatioImage

For images with specific aspect ratios.

```dart
OptimizedAspectRatioImage(
  imageUrl: property.primaryImage,
  aspectRatio: 16 / 9,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
)
```

## 🔧 Parameters

### OptimizedImage

| Parameter               | Type          | Required | Default          | Description          |
| ----------------------- | ------------- | -------- | ---------------- | -------------------- |
| `imageUrl`              | String        | ✅ Yes   | -                | Image URL to load    |
| `width`                 | double?       | No       | null             | Image width          |
| `height`                | double?       | No       | null             | Image height         |
| `fit`                   | BoxFit        | No       | BoxFit.cover     | How image should fit |
| `borderRadius`          | BorderRadius? | No       | null             | Border radius        |
| `shimmerBaseColor`      | Color?        | No       | Colors.grey[300] | Shimmer base color   |
| `shimmerHighlightColor` | Color?        | No       | Colors.grey[100] | Shimmer highlight    |
| `errorWidget`           | Widget?       | No       | Default error    | Custom error widget  |
| `fadeInDuration`        | Duration      | No       | 300ms            | Fade-in animation    |

### OptimizedCircularImage

| Parameter               | Type    | Required | Default          | Description         |
| ----------------------- | ------- | -------- | ---------------- | ------------------- |
| `imageUrl`              | String  | ✅ Yes   | -                | Image URL to load   |
| `size`                  | double  | No       | 50               | Circle diameter     |
| `shimmerBaseColor`      | Color?  | No       | Colors.grey[300] | Shimmer base color  |
| `shimmerHighlightColor` | Color?  | No       | Colors.grey[100] | Shimmer highlight   |
| `errorWidget`           | Widget? | No       | Person icon      | Custom error widget |

### OptimizedAspectRatioImage

| Parameter      | Type          | Required | Default      | Description          |
| -------------- | ------------- | -------- | ------------ | -------------------- |
| `imageUrl`     | String        | ✅ Yes   | -            | Image URL to load    |
| `aspectRatio`  | double        | No       | 16/9         | Aspect ratio         |
| `fit`          | BoxFit        | No       | BoxFit.cover | How image should fit |
| `borderRadius` | BorderRadius? | No       | null         | Border radius        |

## 📝 Usage Examples

### Example 1: Property Card Image

```dart
OptimizedImage(
  imageUrl: property.primaryImage,
  width: double.infinity,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(12),
  ),
)
```

### Example 2: User Avatar

```dart
OptimizedCircularImage(
  imageUrl: user.profileImage,
  size: 60,
)
```

### Example 3: Project Card with Aspect Ratio

```dart
OptimizedAspectRatioImage(
  imageUrl: project.primaryImage,
  aspectRatio: 16 / 9,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(12),
)
```

### Example 4: Custom Error Widget

```dart
OptimizedImage(
  imageUrl: property.primaryImage,
  width: 200,
  height: 150,
  errorWidget: Container(
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.home, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text('Property image unavailable'),
      ],
    ),
  ),
)
```

### Example 5: Custom Shimmer Colors

```dart
OptimizedImage(
  imageUrl: property.primaryImage,
  width: 200,
  height: 150,
  shimmerBaseColor: AppColors.primary.withValues(alpha:0.1),
  shimmerHighlightColor: AppColors.primary.withValues(alpha:0.3),
)
```

## 🔄 Migration Guide

### Step 1: Import the Widget

```dart
import 'package:teacher_app/core/widgets/optimized_image.dart';
```

### Step 2: Replace CachedNetworkImage

**Before:**

```dart
CachedNetworkImage(
  imageUrl: property.primaryImage,
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

**After:**

```dart
OptimizedImage(
  imageUrl: property.primaryImage,
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

### Step 3: Remove Manual Shimmer/Error Handling

**Before:**

```dart
CachedNetworkImage(
  imageUrl: property.primaryImage,
  fit: BoxFit.cover,
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(color: Colors.white),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

**After:**

```dart
OptimizedImage(
  imageUrl: property.primaryImage,
  fit: BoxFit.cover,
  // ✅ Shimmer and error handling automatic!
)
```

## 📍 Priority Migration Locations

### High Priority (Replace First):

1. **Property Cards** (20+ locations)
   - `lib/features/home/presentation/widgets/property_card.dart`
   - `lib/features/search/presentation/widgets/property_card.dart`
   - `lib/features/profile/presentation/offers/widgets/offer_card.dart`

2. **Project Cards** (10+ locations)
   - `lib/features/projects/presentation/widgets/project_list_card.dart`
   - `lib/features/home/presentation/widgets/project_card.dart`

3. **Detail Pages** (5+ locations)
   - `lib/features/property_details/presentation/widgets/property_image_slider.dart`
   - `lib/features/project_details/presentation/widgets/project_image_slider_new.dart`

4. **User Avatars** (5+ locations)
   - `lib/features/profile/presentation/pages/profile_page.dart`
   - `lib/features/agent_details/presentation/pages/agent_details_page.dart`

5. **News Cards** (5+ locations)
   - `lib/features/news/presentation/widgets/news_card.dart`

### Medium Priority:

- Location cards
- Amenity icons
- Company logos
- Notification images

### Low Priority:

- Background images
- Decorative images

## ⚡ Performance Benefits

### Before (Manual Implementation):

```
❌ Inconsistent caching
❌ No shimmer placeholders
❌ Poor error handling
❌ Repeated code (50+ locations)
❌ Hard to maintain
```

### After (OptimizedImage):

```
✅ Automatic caching
✅ Consistent shimmer
✅ Proper error handling
✅ Single source of truth
✅ Easy to maintain
✅ Better UX
```

## 🎨 Customization

### Custom Shimmer Colors

```dart
OptimizedImage(
  imageUrl: url,
  shimmerBaseColor: AppColors.primary.withValues(alpha:0.1),
  shimmerHighlightColor: AppColors.primary.withValues(alpha:0.3),
)
```

### Custom Error Widget

```dart
OptimizedImage(
  imageUrl: url,
  errorWidget: YourCustomErrorWidget(),
)
```

### Custom Fade Duration

```dart
OptimizedImage(
  imageUrl: url,
  fadeInDuration: Duration(milliseconds: 500),
)
```

## 🧪 Testing

The widget is production-ready and includes:

- ✅ Null safety
- ✅ Error handling
- ✅ Memory efficiency
- ✅ Performance optimization

## 📚 Related Files

- **Widget:** `lib/core/widgets/optimized_image.dart`
- **Documentation:** `lib/core/widgets/OPTIMIZED_IMAGE_README.md`
- **Package:** `cached_network_image: ^3.3.1`
- **Package:** `shimmer: ^3.0.0`

## 🚀 Next Steps

1. ✅ Widget created
2. ⏳ Migrate property cards (Priority 1)
3. ⏳ Migrate project cards (Priority 2)
4. ⏳ Migrate detail pages (Priority 3)
5. ⏳ Migrate avatars (Priority 4)
6. ⏳ Migrate news cards (Priority 5)

**Estimated Time:** 2-3 hours for all migrations

---

**Created:** January 31, 2026  
**Status:** ✅ Ready for use  
**Maintainer:** Development Team
