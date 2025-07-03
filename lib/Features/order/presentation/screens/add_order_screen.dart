
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/layouts/custom_section.dart';
import 'package:Tosell/features/order/data/models/Location.dart';
import 'package:Tosell/features/order/data/models/add_order_form.dart';
import 'package:Tosell/features/order/presentation/widgets/Geolocator.dart';
import 'package:Tosell/features/orders/presentation/providers/order_commands_provider.dart';
import 'package:Tosell/features/profile/data/models/zone.dart';
import 'package:Tosell/features/profile/presentation/providers/zone_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'dart:developer' as developer;

class AddOrderScreen extends ConsumerStatefulWidget {
  const AddOrderScreen({super.key});

  @override
  ConsumerState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends ConsumerState<AddOrderScreen> {
  String? selectedPickupZoneId;

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneNumberController =
      TextEditingController();
  final TextEditingController _customerSecondPhoneNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final TextEditingController _orderSizeController =
      TextEditingController(text: '1');

  String? _selectedGovernorateId;
  String? _SelectedCityId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Zone> deliveryZones = [];
  List<Governorate> governorateZones = [];

  Future<void> _loadGovernorate() async {
    final governorates =
        await ref.read(zoneNotifierProvider.notifier).getAllGovernorate();
    setState(() {
      governorateZones = governorates;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadGovernorate();
  }

  Future<void> _loadZones(String governorateId) async {
    final zones = await ref
        .read(zoneNotifierProvider.notifier)
        .getALlZones(governorateId: governorateId);

    var z = deliveryZones;
    setState(() {
      _SelectedCityId = null;
      deliveryZones = zones;
    });
  }

  @override
  Widget build(BuildContext context) {
    var zoneState = ref.watch(zoneNotifierProvider);

    return Scaffold(
      body: zoneState.when(
        data: (data) => _buildUi(context, data),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUi(BuildContext context, List<Zone> pickupZones) {
    var orderState = ref.watch(orderCommandsNotifierProvider);

    void addOrder() async {
      developer.log(
          '🎯 AddOrderScreen.addOrder() - بدء عملية إضافة طلب من الواجهة',
          name: 'AddOrderScreen');

      try {
        // تسجيل بيانات النموذج قبل الإرسال
        developer.log('📋 بيانات النموذج من الواجهة:', name: 'AddOrderScreen');
        developer.log('  - Barcode: ${_barcodeController.text}',
            name: 'AddOrderScreen');
        developer.log('  - Customer Name: ${_customerNameController.text}',
            name: 'AddOrderScreen');
        developer.log(
            '  - Customer Phone: ${_customerPhoneNumberController.text}',
            name: 'AddOrderScreen');
        developer.log(
            '  - Customer Second Phone: ${_customerSecondPhoneNumberController.text}',
            name: 'AddOrderScreen');
        developer.log('  - Selected City ID (Delivery Zone): $_SelectedCityId',
            name: 'AddOrderScreen');
        developer.log('  - Selected Pickup Zone ID: $selectedPickupZoneId',
            name: 'AddOrderScreen');
        developer.log('  - Content: ${_contentController.text}',
            name: 'AddOrderScreen');
        developer.log('  - Amount: ${_amountController.text}',
            name: 'AddOrderScreen');
        developer.log('  - Size: ${_orderSizeController.text}',
            name: 'AddOrderScreen');
        developer.log('  - Note: ${_orderNoteController.text}',
            name: 'AddOrderScreen');

        developer.log('📍 الحصول على الموقع الحالي...', name: 'AddOrderScreen');
        var pickupLocation = await getCurrentLocation();
        developer.log(
            '📍 الموقع الحالي: lat=${pickupLocation.latitude}, long=${pickupLocation.longitude}',
            name: 'AddOrderScreen');

        // إنشاء نموذج الطلب
        final orderForm = AddOrderForm(
          code: _barcodeController.text,
          customerName: _customerNameController.text,
          customerPhoneNumber: _customerPhoneNumberController.text,
          customerSecondPhoneNumber: _customerSecondPhoneNumberController.text,
          deliveryZoneId:
              _SelectedCityId ?? '412', // استخدام 412 كقيمة افتراضية (الغدير)
          note: _orderNoteController.text,
          pickupZoneId: selectedPickupZoneId ?? '',
          content: _contentController.text,
          pickUpLocation: Location(
              lat: pickupLocation.latitude.toString(),
              long: pickupLocation.longitude.toString()),
          size: int.parse(_orderSizeController.text),
          amount: _amountController.text,
        );

        developer.log('🚀 إرسال الطلب إلى المزود...', name: 'AddOrderScreen');
        final result = await ref
            .read(orderCommandsNotifierProvider.notifier)
            .addOrder(orderForm);

        developer.log('📡 نتيجة إضافة الطلب في الواجهة:',
            name: 'AddOrderScreen');
        developer.log('  - Success: ${result.$1 != null}',
            name: 'AddOrderScreen');
        developer.log('  - Order Code: ${result.$1?.code ?? "N/A"}',
            name: 'AddOrderScreen');
        developer.log('  - Error: ${result.$2 ?? "N/A"}',
            name: 'AddOrderScreen');

        if (result.$1 == null) {
          developer.log('❌ فشل في إنشاء الطلب - عرض رسالة خطأ',
              name: 'AddOrderScreen');
          GlobalToast.show(
            context: context,
            message: result.$2!,
          );
        } else {
          developer.log(
              '✅ تم إنشاء الطلب بنجاح - عرض رسالة نجاح والانتقال للطلبات',
              name: 'AddOrderScreen');
          GlobalToast.showSuccess(
            context: context,
            message: "تم انشاء الطلب بنجاح",
          );
          if (orderState is AsyncData) {
            context.go(AppRoutes.orders);
          }
        }
      } catch (e) {
        GlobalToast.show(
          context: context,
          message: "حدث خطأ أثناء إرسال الطلب${e.toString()}.",
        );
      }
    }

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            title: "إنشاء طلب جديد",
            showBackButton: true,
            onBackButtonPressed: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomSection(
                    noLine: true,
                    title: 'موقع إستلام المنتج',
                    icon: SvgPicture.asset(
                      "assets/svg/Receipt.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    leading: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/navigation_add.svg",
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const Gap(AppSpaces.small),
                        Text(
                          "إضافة موقع",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Gap(AppSpaces.small),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 13.0,
                          right: 8.0,
                          left: 8.0,
                        ),
                        child: SizedBox(
                          height: 50, // Fixed height for the ListView
                          child: ListView.builder(
                            itemCount: pickupZones.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final zone = pickupZones[index];
                              final isSelected =
                                  zone.id.toString() == selectedPickupZoneId;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPickupZoneId = zone.id.toString();
                                  });
                                },
                                child: buildZone(context, zone, isSelected),
                              );
                            },
                            itemExtent:
                                330, // Set the item width, making it fixed
                            shrinkWrap: false, // Prevent shrinking the list
                            physics:
                                const ClampingScrollPhysics(), // Better for horizontal scrolling
                          ),
                        ),
                      )
                    ],
                  ),

                  CustomSection(
                    noLine: true,
                    title: "معلومات الوصل",
                    icon: SvgPicture.asset(
                      "assets/svg/navigation_add.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: Form(
                          key: _formKey,
                          child: CustomTextFormField(
                            controller: _barcodeController,
                            label: "رقم الوصل",
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .unfocus(); // This hides the keyboard
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid barcode';
                              }
                              var validate = ref
                                  .read(orderCommandsNotifierProvider.notifier)
                                  .validateCode(code: value)
                                  .then(
                                (value) {
                                  if (!value) return 'Invalid code';
                                },
                              );

                              return null; // Return null if validation passes
                            },
                            // Add validation logic inside the onEditingComplete callback
                            // onEditingComplete: (value) async {
                            //   if (_formKey.currentState?.validate() ?? false) {
                            // var validate = await ref
                            // .read(
                            // orderCommandsNotifierProvider.notifier)
                            // .validateCode(code: value);

                            //     if (validate) {
                            //       // Handle successful validation here
                            //     } else {
                            //       // Handle failure here
                            //       print('Invalid code');
                            //     }
                            //   } else {
                            //     // Form is invalid, show error
                            //     print("Form is invalid!");
                            //   }
                            // },
                            suffixInner: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => scanBarcode(context),
                                child: SvgPicture.asset(
                                  "assets/svg/Barcode.svg",
                                  width: 24,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //? products carts list
                  buildProductCart(context, "لايوجد"),

                  CustomSection(
                    noLine: true,
                    title: "معلومات الزبون",
                    icon: SvgPicture.asset(
                      "assets/svg/box.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          hint: "مثال: \"أحمد علي\"",
                          label: "أسم الزبون",
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                          controller: _customerNameController,
                        ),
                      ),

                      //=======
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          label: "رقم الهاتف",
                          hint: 'مثال: "07x xxx xxxx"',
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                          controller: _customerPhoneNumberController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          label: "رقم الهاتف الثاني",
                          hint: 'مثال: "07x xxx xxxx"',
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                          controller: _customerSecondPhoneNumberController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField<String>(
                          label: "المحافظة",
                          hint: "مثال: 'بغداد'",
                          dropdownItems: governorateZones.map((gov) {
                            return DropdownMenuItem<String>(
                              value: gov.id?.toString() ?? '',
                              child: Text(gov.name ?? 'Unknown'),
                            );
                          }).toList(),
                          // controller: _governorateIdController,
                          selectedValue: _selectedGovernorateId,
                          onDropdownChanged: (value) => _loadZones(value ?? ''),

                          suffixInner: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(
                                "assets/svg/CaretDown.svg",
                                width: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField<String>(
                          label: "المنطقة",
                          hint: "مثال: \'المنصور\'",
                          // controller: _CityIdController,
                          dropdownItems: deliveryZones.isNotEmpty
                              ? deliveryZones.map((zone) {
                                  return DropdownMenuItem<String>(
                                    value: zone.id?.toString() ?? '',
                                    child: Text(zone.name ?? 'Unknown'),
                                  );
                                }).toList()
                              : [],

                          selectedValue: _SelectedCityId,
                          onDropdownChanged: (value) {
                            setState(() {
                              _SelectedCityId = value;
                            });
                          },
                          suffixInner: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(
                                "assets/svg/CaretDown.svg",
                                width: 24,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  CustomSection(
                    noLine: true,
                    title: "معلومات الطلب",
                    icon: SvgPicture.asset(
                      "assets/svg/navigation_add.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                      //=======
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                          child: CustomTextFormField<String>(
                            label: "حجم الطلب",
                            hint: "متوسط",
                            controller: _orderSizeController,
                            dropdownItems: const [
                              DropdownMenuItem(
                                value: "0",
                                child: Text("صغير"),
                              ),
                              DropdownMenuItem(
                                value: "1",
                                child: Text("متوسط"),
                              ),
                              DropdownMenuItem(
                                value: "2",
                                child: Text("كبير"),
                              ),
                            ],
                            selectedValue: "1",
                            onDropdownChanged: (value) {},
                            suffixInner: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: SvgPicture.asset(
                                  "assets/svg/CaretDown.svg",
                                  width: 24,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          )),
                      //=======
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          label: "ملاحظة",
                          hint: 'مثال: "المادة قابلة للكسر"',
                          maxLines: 3,
                          controller: _orderNoteController,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                        ),
                      ),
                    ],
                  ),
                  //? send button
                  const Gap(AppSpaces.exLarge),
                  Container(
                    padding: AppSpaces.allMedium,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: FillButton(
                      label: 'إرسال الطلب',
                      isLoading: orderState.isLoading,
                      onPressed: () => addOrder(),
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomSection buildProductCart(BuildContext context, String product) {
    return CustomSection(
      noLine: true,
      title: 'معلومات المنتج',
      icon: SvgPicture.asset(
        "assets/svg/box.svg",
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
          child: CustomTextFormField(
            label: "تفاصيل المنتج",
            controller: _contentController,
            hint: " مثال: \'صندوق ادوات كهرباء\'",
            maxLines: 3,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus(); // This hides the keyboard
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
          child: CustomTextFormField(
            label: "سعر المنتج",
            controller: _amountController,
            hint: " مثال: \'30,000 \'",
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus(); // This hides the keyboard
            },
          ),
        ),
      ],
    );
  }

  Widget buildZone(BuildContext context, Zone zone, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Gap(AppSpaces.medium),
          SizedBox(
            width: 18,
            height: 18,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(3),
              ),
            ),
          ),
          const Gap(AppSpaces.exSmall),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/MapPinSimple.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name ?? "لايوجد",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    zone.governorate?.name ?? "لايوجد",
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scanBarcode(BuildContext context) async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Test',
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
    );
    setState(() {
      _barcodeController.text = res ?? '';
    });
  }
}
