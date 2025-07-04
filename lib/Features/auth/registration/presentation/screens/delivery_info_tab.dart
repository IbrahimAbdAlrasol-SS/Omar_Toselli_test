import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/inputs/custom_search_drop_down.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import 'package:Tosell/features/profile/data/services/governorate_service.dart';
import 'package:Tosell/features/profile/data/services/zone_service.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ZoneLocationInfo {
  Governorate? selectedGovernorate;
  Zone? selectedZone;
  String nearestLandmark;
  double? latitude;
  double? longitude;

  ZoneLocationInfo({
    this.selectedGovernorate,
    this.selectedZone,
    this.nearestLandmark = '',
    this.latitude,
    this.longitude,
  });

  ZoneLocationInfo copyWith({
    Governorate? selectedGovernorate,
    Zone? selectedZone,
    String? nearestLandmark,
    double? latitude,
    double? longitude,
  }) {
    return ZoneLocationInfo(
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedZone: selectedZone ?? this.selectedZone,
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Zone? toZone() {
    if (selectedZone == null) {
      return null;
    }

    return Zone(
      id: selectedZone!.id,
      name: selectedZone!.name,
      type: selectedZone!.type,
      governorate: selectedZone!.governorate,
    );
  }

  bool get isValid =>
      selectedZone != null &&
      nearestLandmark.isNotEmpty &&
      latitude != null &&
      longitude != null;
}

class DeliveryInfoTab extends ConsumerStatefulWidget {
  final Function({
    required List<Zone> zones,
    double? latitude,
    double? longitude,
    String? nearestLandmark,
  }) onZonesChangedWithLocation;
  final List<Zone> initialZones;

  const DeliveryInfoTab({
    super.key,
    required this.onZonesChangedWithLocation,
    this.initialZones = const [],
  });

  @override
  ConsumerState<DeliveryInfoTab> createState() => DeliveryInfoTabState();
}

class DeliveryInfoTabState extends ConsumerState<DeliveryInfoTab> {
  Set<int> expandedTiles = {};
  final GovernorateService _governorateService = GovernorateService();
  final ZoneService _zoneService = ZoneService();

  List<ZoneLocationInfo> zones = [];

  @override
  void initState() {
    super.initState();

    if (widget.initialZones.isNotEmpty) {
      zones = widget.initialZones
          .map((zone) => ZoneLocationInfo(selectedZone: zone))
          .toList();
    } else {
      zones = [ZoneLocationInfo()];
    }
  }

  void _updateParent() {
    final validZones = zones
        .where((zone) => zone.selectedZone != null)
        .map((zone) => zone.toZone())
        .where((zone) => zone != null)
        .cast<Zone>()
        .toList();

    final firstValidZone = zones.firstWhere((zone) => zone.isValid,
        orElse: () => ZoneLocationInfo());

    widget.onZonesChangedWithLocation(
      zones: validZones,
      latitude: firstValidZone.latitude,
      longitude: firstValidZone.longitude,
      nearestLandmark: firstValidZone.nearestLandmark,
    );
  }

  void clearAllFields() {
    setState(() {
      zones = [ZoneLocationInfo()];
      expandedTiles.clear();
    });
    _updateParent();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...zones.asMap().entries.map((entry) {
              final index = entry.key;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: _buildLocationCard(index, zones[index]),
              );
            }),
            const Gap(5),
            _buildAddLocationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(int index, ZoneLocationInfo zoneInfo) {
    bool isExpanded = expandedTiles.contains(index);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFFFBFAFF), // Surface color from light theme
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isExpanded ? 16 : 64),
        side: const BorderSide(
            width: 1,
            color: Color(0xFFEAEEF0)), // Outline color from light theme
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                "عنوان إستلام البضاعة ${index + 1}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Tajawal",
                  color: const Color(
                      0xFF1C1B1F), // OnSurface color from light theme
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (zones.length > 1)
              IconButton(
                onPressed: () => _removeLocation(index),
                icon: const Icon(Icons.delete_outline,
                    color: Color(0xFFD54444),
                    size: 20), // Error color from light theme
              ),
          ],
        ),
        trailing: SvgPicture.asset(
          "assets/svg/downrowsvg.svg",
          color: const Color(0xFF16CA8B), // Primary color from light theme
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              expandedTiles.add(index);
            } else {
              expandedTiles.remove(index);
            }
          });
        },
        children: [
          Container(
              height: 1,
              color: const Color(0xFFEAEEF0)), // Outline color from light theme
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGovernorateDropdown(index, zoneInfo),
                const Gap(5),
                _buildZoneDropdown(index, zoneInfo),
                const Gap(5),
                _buildNearestPointField(index, zoneInfo),
                const Gap(5),
                _buildLocationPicker(index, zoneInfo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovernorateDropdown(int index, ZoneLocationInfo zoneInfo) {
    return RegistrationSearchDropDown<Governorate>(
      label: "المحافظة",
      hint: "ابحث عن المحافظة... مثال: 'بغداد'",
      selectedValue: zoneInfo.selectedGovernorate,
      itemAsString: (gov) => gov.name ?? '',
      asyncItems: (query) async {
        try {
          print('🏛️ جلب المحافظات - البحث: "$query"');
          final governorates = await _governorateService.getAllZones();
          print('📊 تم جلب ${governorates.length} محافظة من الخادم');

          if (query.trim().isNotEmpty) {
            final filtered = governorates
                .where((gov) =>
                    gov.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false)
                .toList();
            print('🔍 بعد البحث: ${filtered.length} محافظة');
            return filtered;
          }

          return governorates;
        } catch (e) {
          print('❌ خطأ في جلب المحافظات: $e');
          return [];
        }
      },
      onChanged: (governorate) {
        print('🏛️ تم اختيار المحافظة: ${governorate?.name} (معرف: ${governorate?.id})');
        setState(() {
          zones[index] = zones[index].copyWith(
            selectedGovernorate: governorate,
            selectedZone: null, // مسح المنطقة المختارة عند تغيير المحافظة
          );
          if (zones[index].selectedZone != null) {
            print('🔄 تم مسح اختيار المنطقة السابقة');
          }
        });
        _updateParent();
      },
      itemBuilder: (context, governorate) => Row(
        children: [
          Icon(Icons.location_city,
              color: const Color(0xFF16CA8B),
              size: 18), // Primary color from light theme
          const Gap(8),
          Expanded(
            child: Text(
              governorate.name ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: "Tajawal",
              ),
            ),
          ),
        ],
      ),
      emptyText: "لا توجد محافظات",
      errorText: "خطأ في تحميل المحافظات",
      enableRefresh: true,
    );
  }

  // تحديث دالة buildZoneDropdown في delivery_info_tab.dart
// تحديث دالة buildZoneDropdown في delivery_info_tab.dart
Widget _buildZoneDropdown(int index, ZoneLocationInfo zoneInfo) {
  final selectedGov = zoneInfo.selectedGovernorate;

  return RegistrationSearchDropDown<Zone>(
    label: "المنطقة",
    hint: selectedGov == null
        ? "اختر المحافظة أولاً"
        : zoneInfo.selectedZone?.name ?? "ابحث عن المنطقة في ${selectedGov.name}...",
    itemAsString: (zone) => zone.name ?? '',
    asyncItems: (query) async {
      if (selectedGov?.id == null) {
        return [];
      }

      try {
        print('🔍 محاولة جلب مناطق المحافظة:');
        print('   - اسم المحافظة: ${selectedGov!.name}');
        print('   - معرف المحافظة: ${selectedGov.id}');
        print('   - نص البحث: "$query"');

        // جلب جميع المناطق من API
        final allZones = await _zoneService.getAllZones();
        print('📊 إجمالي المناطق من API: ${allZones.length}');
        
        // إضافة تشخيص مفصل لمرة واحدة
        if (query.isEmpty && allZones.isNotEmpty) {
          print('\n📋 تشخيص البيانات المستلمة:');
          
          // إحصائيات حسب المحافظة
          final governorateStats = <String, List<String>>{};
          for (final zone in allZones) {
            final govName = zone.governorate?.name ?? 'غير محدد';
            final govId = zone.governorate?.id?.toString() ?? 'null';
            final key = '$govName (ID: $govId)';
            
            if (!governorateStats.containsKey(key)) {
              governorateStats[key] = [];
            }
            governorateStats[key]!.add(zone.name ?? 'بدون اسم');
          }
          
          print('📊 توزيع المناطق حسب المحافظة:');
          governorateStats.forEach((gov, zones) {
            print('   - $gov: ${zones.length} منطقة');
            if (zones.length <= 5) {
              print('     المناطق: ${zones.join(', ')}');
            } else {
              print('     أول 5 مناطق: ${zones.take(5).join(', ')}...');
            }
          });
          
          // فحص أنواع المعرفات
          final uniqueGovIds = allZones
              .map((z) => z.governorate?.id)
              .where((id) => id != null)
              .toSet();
          print('\n🔢 معرفات المحافظات الموجودة: $uniqueGovIds');
          print('   - عدد المحافظات الفريدة: ${uniqueGovIds.length}');
        }

        // فلترة المناطق حسب المحافظة المحددة
        var filteredZones = allZones.where((zone) {
          if (zone.governorate?.id == null) {
            return false;
          }
          
          final zoneGovId = zone.governorate!.id;
          final selectedGovId = selectedGov.id;
          
          // مقارنة المعرفات بطرق مختلفة
          bool matches = false;
          
          // مقارنة مباشرة
          if (zoneGovId == selectedGovId) {
            matches = true;
          }
          // مقارنة كنص
          else if (zoneGovId.toString() == selectedGovId.toString()) {
            matches = true;
          }
          // مقارنة كأرقام
          else {
            try {
              final zoneIdInt = int.tryParse(zoneGovId.toString());
              final selectedIdInt = int.tryParse(selectedGovId.toString());
              if (zoneIdInt != null && selectedIdInt != null && zoneIdInt == selectedIdInt) {
                matches = true;
              }
            } catch (e) {
              // تجاهل أخطاء التحويل
            }
          }
          
          return matches;
        }).toList();
        
        print('🎯 المناطق المفلترة للمحافظة ${selectedGov.name}: ${filteredZones.length}');
        
        // إذا لم نجد مناطق، اطبع تشخيص إضافي
        if (filteredZones.isEmpty) {
          print('\n⚠️ تحذير: لا توجد مناطق للمحافظة ${selectedGov.name} (ID: ${selectedGov.id})');
          print('🔍 التحقق من المشكلة:');
          
          // فحص هل المحافظة موجودة في البيانات
          final hasGovernorate = allZones.any((z) => 
            z.governorate?.id?.toString() == selectedGov.id.toString() ||
            z.governorate?.name == selectedGov.name
          );
          
          if (!hasGovernorate) {
            print('   ❌ المحافظة ${selectedGov.name} غير موجودة في بيانات المناطق');
            print('   💡 الحل: يجب إضافة مناطق لهذه المحافظة في قاعدة البيانات');
          } else {
            print('   ⚠️ المحافظة موجودة لكن المعرفات لا تتطابق');
            print('   💡 الحل: التحقق من أنواع البيانات في API');
          }
        }

        // فلترة حسب البحث
        if (query.trim().isNotEmpty && filteredZones.isNotEmpty) {
          filteredZones = filteredZones
              .where((zone) =>
                  zone.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList();
          print('🔍 بعد البحث عن "$query": ${filteredZones.length} منطقة');
        }

        return filteredZones;
      } catch (e, stackTrace) {
        print('❌ خطأ في جلب المناطق: $e');
        print('📍 تفاصيل الخطأ: $stackTrace');
        return [];
      }
    },
    onChanged: (zone) {
      print('✅ تم اختيار المنطقة: ${zone?.name}');
      setState(() {
        zones[index] = zones[index].copyWith(selectedZone: zone);
      });
      _updateParent();
    },
    itemBuilder: (context, zone) => Row(
      children: [
        Icon(Icons.place,
            color: const Color(0xFF16CA8B),
            size: 18),
        const Gap(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zone.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: "Tajawal",
                ),
              ),
              if (zone.type != null)
                Text(
                  zone.type == 1 ? 'المركز' : 'الأطراف',
                  style: TextStyle(
                    fontSize: 12,
                    color: zone.type == 1
                        ? const Color(0xFF16CA8B)
                        : const Color(0xFF698596),
                    fontFamily: "Tajawal",
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
    emptyText: selectedGov == null
        ? "اختر المحافظة أولاً"
        : "لا توجد مناطق متاحة في ${selectedGov.name}",
    errorText: "خطأ في تحميل المناطق",
    enableRefresh: true,
  );
}

  Widget _buildNearestPointField(int index, ZoneLocationInfo zoneInfo) {
    return CustomTextFormField(
      label: "اقرب نقطة دالة",
      hint: "مثال: 'قرب مطعم الخيمة'",
      selectedValue: zoneInfo.nearestLandmark,
      onChanged: (value) {
        setState(() {
          zones[index] = zones[index].copyWith(nearestLandmark: value);
        });
        _updateParent();
      },
    );
  }

  Widget _buildLocationPicker(int index, ZoneLocationInfo zoneInfo) {
    final hasLocation = zoneInfo.latitude != null && zoneInfo.longitude != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الموقع على الخريطة',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
        ),
        const Gap(5),
        InkWell(
          onTap: () => _openLocationPicker(index, zoneInfo),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasLocation
                    ? const Color(0xFF16CA8B) // Primary color from light theme
                    : const Color(0xFFEAEEF0), // Outline color from light theme
                width: hasLocation ? 2 : 1,
              ),
              color: hasLocation
                  ? const Color(0xFF16CA8B)
                      .withOpacity(0.05) // Primary color from light theme
                  : const Color(
                      0xFFE7E0EC), // SurfaceVariant color from light theme
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/svg/MapPinLine.svg',
                    color: hasLocation
                        ? const Color(
                            0xFF16CA8B) // Primary color from light theme
                        : const Color(
                            0xFFEAEEF0), // Outline color from light theme
                    height: 24,
                  ),
                  const Gap(15),
                  Text(
                    hasLocation ? 'تم تحديد الموقع' : 'تحديد الموقع',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: hasLocation
                          ? const Color(
                              0xFF16CA8B) // Primary color from light theme
                          : const Color(
                              0xFFEAEEF0), // Outline color from light theme
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasLocation) ...[
                    const Gap(4),
                    Text(
                      'اضغط للتعديل',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF16CA8B)
                            .withOpacity(0.7), // Primary color from light theme
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddLocationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 140.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: const Color(0xFF16CA8B)
                .withOpacity(0.2), // Primary color from light theme
            borderRadius: BorderRadius.circular(60),
            border: Border.all(
                color:
                    const Color(0xFF16CA8B)), // Primary color from light theme
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {
              setState(() {
                zones.add(ZoneLocationInfo());
              });
              _updateParent();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/svg/navigation_add.svg",
                    color: const Color(
                        0xFF16CA8B), // Primary color from light theme
                    height: 20,
                  ),
                  const Gap(5),
                  Text(
                    "إضافة موقع",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color(
                          0xFF16CA8B), // Primary color from light theme
                      fontFamily: "Tajawal",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeLocation(int index) {
    if (zones.length <= 1) return;

    setState(() {
      zones.removeAt(index);
      expandedTiles.remove(index);
    });
    _updateParent();
  }

  Future<void> _openLocationPicker(int index, ZoneLocationInfo zoneInfo) async {
    try {
      final result = await context.push(
        AppRoutes.mapSelection,
        extra: {
          'latitude': zoneInfo.latitude,
          'longitude': zoneInfo.longitude,
        },
      );

      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          zones[index] = zones[index].copyWith(
            latitude: result['latitude'],
            longitude: result['longitude'],
          );
        });
        _updateParent();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle,
                    color: const Color(0xFFFFFFFF)), // White color
                const Gap(8),
                Text('تم حفظ الموقع بنجاح',
                    style: const TextStyle(fontFamily: "Tajawal")),
              ],
            ),
            backgroundColor:
                const Color(0xFF16CA8B), // Primary color from light theme
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ في فتح الخريطة',
              style: const TextStyle(fontFamily: "Tajawal")),
          backgroundColor:
              const Color(0xFFD54444), // Error color from light theme
        ),
      );
    }
  }
}
