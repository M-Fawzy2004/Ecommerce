import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class PaymobRemoteDataSource {
  Future<String> getPaymentKey({
    required double amount,
    required String currency,
    required String orderId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  });
}

class PaymobRemoteDataSourceImpl implements PaymobRemoteDataSource {
  final Dio dio;

  PaymobRemoteDataSourceImpl(this.dio);

  String get _apiKey => dotenv.get('PAYMOB_API_KEY');
  String get _integrationId => dotenv.get('PAYMOB_INTEGRATION_ID');

  @override
  Future<String> getPaymentKey({
    required double amount,
    required String currency,
    required String orderId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    // 1. Get Auth Token
    final authResponse = await dio.post(
      'https://accept.paymob.com/api/auth/tokens',
      data: {'api_key': _apiKey},
    );
    final String token = authResponse.data['token'];

    // 2. Create Order
    final orderResponse = await dio.post(
      'https://accept.paymob.com/api/ecommerce/orders',
      data: {
        'auth_token': token,
        'delivery_needed': 'false',
        'amount_cents': (amount * 100).toInt().toString(),
        'currency': currency,
        'merchant_order_id': orderId,
        'items': [],
      },
    );
    final String paymobOrderId = orderResponse.data['id'].toString();

    // 3. Generate Payment Key
    final paymentKeyResponse = await dio.post(
      'https://accept.paymob.com/api/acceptance/payment_keys',
      data: {
        'auth_token': token,
        'amount_cents': (amount * 100).toInt().toString(),
        'expiration': 3600,
        'order_id': paymobOrderId,
        'billing_data': {
          'apartment': 'NA',
          'email': email,
          'floor': 'NA',
          'first_name': firstName,
          'street': 'NA',
          'building': 'NA',
          'phone_number': phone,
          'shipping_method': 'NA',
          'postal_code': 'NA',
          'city': 'NA',
          'country': 'NA',
          'last_name': lastName,
          'state': 'NA',
        },
        'currency': currency,
        'integration_id': _integrationId,
      },
    );

    return paymentKeyResponse.data['token'];
  }
}
