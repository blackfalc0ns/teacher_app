# Property Validators

## Overview
Reusable validation class for property submission forms with comprehensive checks for language, length, and phone number detection.

## Features
- ✅ Arabic/English language detection
- ✅ Arabic digits normalization (٠-٩ → 0-9)
- ✅ Phone number detection (even with spaces/dashes)
- ✅ Configurable length limits per field type
- ✅ Bilingual error messages (Arabic/English)
- ✅ Phone blocking in description fields

## Field Types

### PropertyFieldType Enum
```dart
enum PropertyFieldType {
  title,        // 5-100 characters
  address,      // 5-200 characters
  description,  // 20-2000 characters
}
```

## Usage

### Basic Validation

#### Arabic Field
```dart
PropertyValidators.validateArabicField(
  context,
  value,
  type: PropertyFieldType.title,
  blockPhones: false,
)
```

#### English Field
```dart
PropertyValidators.validateEnglishField(
  context,
  value,
  type: PropertyFieldType.description,
  blockPhones: true, // Block phone numbers in description
)
```

### In TextField
```dart
TextField(
  onChanged: (value) {
    setState(() {
      _error = PropertyValidators.validateArabicField(
        context,
        value,
        type: PropertyFieldType.title,
      );
    });
  },
)
```

## Validation Rules

### Language Detection
- **Arabic**: Detects Unicode range `\u0600-\u06FF` and `\u0750-\u077F`
- **English**: Detects `a-zA-Z`

### Phone Number Detection
Detects Egyptian phone numbers in various formats with **production-ready accuracy**:

**Formats detected:**
- `01012345678` (local format)
- `+20 101 234 5678` (international with spaces)
- `010-123-45-678` (with dashes)
- `+201012345678` (international compact)
- `٠١٠١٢٣٤٥٦٧٨` (Arabic digits)

**Patterns:**
- Egyptian mobile: `01[0|1|2|5]` + 8 digits
- International: `(?:\+20|20|0020)` + mobile number (fixed regex for proper matching)
- Fallback (non-strict): Any 8+ consecutive digits

**Technical Improvements:**
1. **Fixed International Regex**: Changed from `\+?20?1[0125]\d{8}` to `(?:\+20|20|0020)1[0125]\d{8}` to properly match international prefixes
2. **Improved Plus Handling**: `digitsOnlyWithOptionalLeadingPlus()` now only preserves `+` at the start of the string
3. **Enhanced Keyword Detection**: Catches suspicious keywords + any digits (even if < 8 digits)

**Anti-Fraud Keywords Detection:**
Also detects suspicious keyword + digits combinations:
- `"واتساب: 010 123"` ❌
- `"call me 010"` ❌
- `"رقمي 010"` ❌
- `"whatsapp 010"` ❌

**Suspicious Keywords:**
- **Arabic**: واتساب، واتس، وتساب، رقم، رقمي، تواصل، اتصل، اتصال، موبايل، جوال، تليفون، هاتف، فون، كلمني، كلمنى، اتصلي، اتصلى
- **English**: whatsapp, whats app, whatsup, phone, mobile, call, contact, number, tel, telephone, reach, text, message, msg

### Length Limits

| Field Type | Min | Max |
|------------|-----|-----|
| Title | 5 | 100 |
| Address | 5 | 200 |
| Description | 20 | 2000 |

## Error Messages

### Arabic Messages
- `هذا الحقل يقبل اللغة العربية فقط`
- `هذا الحقل يقبل اللغة الإنجليزية فقط`
- `ممنوع كتابة رقم هاتف/واتساب داخل هذا الحقل`
- `العنوان يجب أن يكون 5 أحرف على الأقل`
- `الوصف يجب ألا يتجاوز 2000 حرف`

### English Messages
- `This field accepts Arabic only`
- `This field accepts English only`
- `Phone/WhatsApp numbers are not allowed in this field`
- `Title must be at least 5 characters`
- `Description must not exceed 2000 characters`

## Advanced Features

### Digit Normalization
```dart
// Converts Arabic digits to English
PropertyValidators.normalizeDigits('٠١٢٣٤٥٦٧٨٩');
// Returns: '0123456789'
```

### Phone Detection
```dart
// Strict mode (Egyptian numbers only)
PropertyValidators.containsPhoneNumber('اتصل على 01012345678', strict: true);
// Returns: true

// Non-strict mode (any 8+ digits)
PropertyValidators.containsPhoneNumber('الرقم: 12345678', strict: false);
// Returns: true
```

### Language Checks
```dart
PropertyValidators.containsArabic('مرحبا Hello');  // true
PropertyValidators.containsEnglish('مرحبا Hello'); // true
```

## Implementation Example

### In DetailsStep
```dart
class _DetailsStepState extends State<DetailsStep> {
  final Map<String, String?> _validationErrors = {};

  PropertyFieldType? _mapFieldType(String fieldKey) {
    if (fieldKey.contains('title')) return PropertyFieldType.title;
    if (fieldKey.contains('address')) return PropertyFieldType.address;
    if (fieldKey.contains('description')) return PropertyFieldType.description;
    return null;
  }

  Widget _buildTextField({
    required String fieldKey,
    required bool? isArabic,
    // ... other params
  }) {
    return TextField(
      onChanged: (value) {
        final type = _mapFieldType(fieldKey);
        
        if (isArabic != null && type != null) {
          setState(() {
            final blockPhones = type == PropertyFieldType.description;
            
            _validationErrors[fieldKey] = isArabic
                ? PropertyValidators.validateArabicField(
                    context,
                    value,
                    type: type,
                    blockPhones: blockPhones,
                  )
                : PropertyValidators.validateEnglishField(
                    context,
                    value,
                    type: type,
                    blockPhones: blockPhones,
                  );
          });
        }
      },
    );
  }
}
```

## Anti-Fraud Features

### Phone Number Blocking
Prevents users from bypassing the contact system by including phone numbers in descriptions:

```dart
// ❌ Will be rejected
"شقة للبيع اتصل على 01012345678"
"Apartment for sale call +20 101 234 5678"
"للتواصل: 010-123-456-78"

// ✅ Will be accepted
"شقة للبيع في موقع ممتاز"
"Apartment for sale in prime location"
```

### Smart Detection
- Handles Arabic digits: `٠١٠١٢٣٤٥٦٧٨`
- Handles separators: `010-123-45-678`
- Handles spaces: `010 123 456 78`
- Handles parentheses: `(010) 123-4567`
- **Detects keyword tricks**: `"واتساب 010"`, `"call 010"`, `"رقمي 010"`
- **Plus sign handling**: Only preserves `+` at the start (e.g., `"+20 10-123"` → `"+2010123"`)
- **Prevents word-based bypass**: `"صفر واحد صفر"` (future enhancement)

## Testing

### Test Cases
```dart
// Language validation
assert(PropertyValidators.containsArabic('مرحبا') == true);
assert(PropertyValidators.containsEnglish('Hello') == true);

// Phone detection
assert(PropertyValidators.containsPhoneNumber('01012345678') == true);
assert(PropertyValidators.containsPhoneNumber('+20 101 234 5678') == true);
assert(PropertyValidators.containsPhoneNumber('شقة للبيع') == false);

// Keyword detection
assert(PropertyValidators.containsSuspiciousKeywords('واتساب') == true);
assert(PropertyValidators.containsSuspiciousKeywords('whatsapp') == true);
assert(PropertyValidators.containsSuspiciousKeywords('شقة للبيع') == false);

// Combined detection (keyword + digits)
assert(PropertyValidators.containsPhoneNumber('واتساب 010', strict: false) == true);
assert(PropertyValidators.containsPhoneNumber('call 010', strict: false) == true);

// Digit normalization
assert(PropertyValidators.normalizeDigits('٠١٢') == '012');

// Plus handling
assert(PropertyValidators.digitsOnlyWithOptionalLeadingPlus('+20 101') == '+20101');
assert(PropertyValidators.digitsOnlyWithOptionalLeadingPlus('010 123') == '010123');
```

## Benefits

### For Users
- Clear, bilingual error messages
- Prevents accidental language mixing
- Guides proper input format

### For Platform
- Prevents contact system bypass
- Maintains data quality
- Enforces business rules
- Reduces spam/fraud

### For Developers
- Reusable across all forms
- Clean, maintainable code
- Easy to extend
- Well-documented

## Future Enhancements
- [ ] Support for more countries' phone formats
- [ ] Email detection in descriptions
- [ ] URL detection and blocking
- [ ] Custom regex patterns per field
- [ ] Profanity filtering
