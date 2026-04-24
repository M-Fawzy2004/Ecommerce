// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/theme/app_text_styles.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/core/widgets/app_back_button.dart';
import 'package:ecommerce_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AddressPickerPage extends StatefulWidget {
  const AddressPickerPage({super.key});

  @override
  State<AddressPickerPage> createState() => _AddressPickerPageState();
}

class _AddressPickerPageState extends State<AddressPickerPage> {
  LatLng _selectedLocation = const LatLng(30.0444, 31.2357); // Cairo, Egypt
  String _address = "Fetching address...";
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAddress(_selectedLocation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = LatLng(locations[0].latitude, locations[0].longitude);
        setState(() {
          _selectedLocation = loc;
        });
        _mapController.move(loc, 15);
        _getAddress(loc);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location not found')));
    }
  }

  Future<void> _getAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          final List<String> parts = [];
          if (place.name != null &&
              place.name!.isNotEmpty &&
              place.name != place.street) {
            parts.add(place.name!);
          }
          if (place.street != null && place.street!.isNotEmpty) {
            parts.add(place.street!);
          }
          if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            parts.add(place.subLocality!);
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            parts.add(place.locality!);
          }
          if (place.country != null && place.country!.isNotEmpty) {
            parts.add(place.country!);
          }
          _address = parts.join(', ');
          _searchController.text = _address;
        });
      } else {
        await _getAddressFromNominatim(location);
      }
    } catch (e) {
      await _getAddressFromNominatim(location);
    }
  }

  Future<void> _getAddressFromNominatim(LatLng location) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': location.latitude,
          'lon': location.longitude,
          'zoom': 18,
          'addressdetails': 1,
        },
        options: Options(headers: {'User-Agent': 'EcommerceApp/1.0'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final String? displayName = data['display_name'];
        if (displayName != null) {
          setState(() {
            _address = displayName;
            _searchController.text = _address;
          });
        }
      }
    } catch (e) {
      setState(() {
        _address =
            "Location: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled')),
          );
        }
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      final newLoc = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = newLoc;
      });
      _mapController.move(newLoc, 15);
      _getAddress(newLoc);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please RESTART the app to enable location features.',
            ),
          ),
        );
      }
    }
  }

  void _zoom(double delta) {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 15,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
                _getAddress(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ecommerce.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 40.r,
                    height: 40.r,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.error,
                      size: 30.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Top Overlay (Back button + Address)
          Positioned(
            top: 50.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              children: [
                Row(
                  children: [
                    const AppBackButton(),
                    AppSpacing.w12,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _searchAddress,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for a place...',
                            hintStyle: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textHint,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20.sp,
                              color: AppColors.primary,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.close, size: 18.sp),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Zoom & Location Controls
          Positioned(
            right: 16.w,
            bottom: 120.h,
            child: Column(
              children: [
                _buildMapActionBtn(Icons.add, () => _zoom(1)),
                AppSpacing.h8,
                _buildMapActionBtn(Icons.remove, () => _zoom(-1)),
                AppSpacing.h16,
                _buildMapActionBtn(
                  Icons.my_location,
                  _getCurrentLocation,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          // Confirm Button
          Positioned(
            bottom: 40.h,
            left: 20.w,
            right: 20.w,
            child: AppButton(
              text: 'Confirm Location',
              onPressed: () {
                Navigator.pop(context, {
                  'location': _selectedLocation,
                  'address': _address,
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapActionBtn(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
          ],
        ),
        child: Icon(icon, color: color ?? AppColors.textPrimary, size: 24.sp),
      ),
    );
  }
}
