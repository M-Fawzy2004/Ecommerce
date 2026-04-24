import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/features/categories/domain/entities/category_entity.dart';

extension CategoryTranslation on CategoryEntity {
  /// Returns the translated name of the category using its key.
  /// Falls back to the [name] from the database if no translation is found.
  String get translatedName {
    // If the key is 'loading', return the name as is
    if (key == 'loading') return name;

    final translationKey = 'categories.${key.toLowerCase()}';
    final translated = translationKey.tr();
    
    // easy_localization returns the key itself if no translation is found
    return (translated == translationKey) ? name : translated;
  }
}
