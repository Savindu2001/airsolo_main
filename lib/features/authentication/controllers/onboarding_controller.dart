import 'package:airsolo/features/authentication/screens/loging/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeStorage();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> _initializeStorage() async {
    try {
      await GetStorage.init();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing GetStorage: $e');
      }
    }
  }

  /// Update Current Index When page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to The Specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update Current Index & Jump to next The page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      _handleOnboardingCompletion();
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  Future<void> _handleOnboardingCompletion() async {
    try {
      if (kDebugMode) {
        print('============================= GET STORAGE Next Button =============================');
        print(storage.read('isFirstTime'));
      }

      await storage.write('isFirstTime', false);

      if (kDebugMode) {
        print('============================= GET STORAGE Next Button =============================');
        print(storage.read('isFirstTime'));
      }

      // Add delay to ensure navigation safety
      await Future.delayed(const Duration(milliseconds: 300));
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      if (kDebugMode) {
        print('Error during onboarding completion: $e');
      }
      // Fallback navigation
      Get.offAll(() => const LoginScreen());
    }
  }

  /// Update Current Index & Jump to last The page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}