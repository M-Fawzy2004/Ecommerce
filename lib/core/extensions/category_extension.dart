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

  /// Returns a fallback image URL based on the category key if no image is provided.
  String get fallbackImage {
    final normalizedKey = key.toLowerCase();
    if (_fixedImages.containsKey(normalizedKey)) {
      return _fixedImages[normalizedKey]!;
    }
    return 'https://images.unsplash.com/featured/?$normalizedKey';
  }

  static const Map<String, String> _fixedImages = {
    'sports':
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&q=80&w=300',
    'electronics':
        'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&q=80&w=300',
    'laptop':
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&q=80&w=300',
    'laptops':
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&q=80&w=300',
    'fashion':
        'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&q=80&w=300',
    'womens_fashion':
        'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&q=80&w=300',
    'mens_fashion':
        'https://images.unsplash.com/photo-1488161628813-04466f872be2?auto=format&fit=crop&q=80&w=300',
    'mobile':
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=300',
    'smartphones':
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=300',
    'tablet':
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&q=80&w=300',
    'appliances':
        'https://images.unsplash.com/photo-1584622781564-1d9876a13d00?auto=format&fit=crop&q=80&w=300',
    'headphones':
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&q=80&w=300',
    'tshirt':
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&q=80&w=300',
  };
}
