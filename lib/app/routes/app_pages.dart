import 'package:get/get.dart';

import '../../modules/add_event/add_event_binding.dart';
import '../../modules/add_event/add_event_view.dart';
import '../../modules/add_reminder/add_reminder_binding.dart';
import '../../modules/add_reminder/add_reminder_view.dart';
import '../../modules/add_vehicle/add_vehicle_binding.dart';
import '../../modules/add_vehicle/add_vehicle_view.dart';
import '../../modules/auth/login_binding.dart';
import '../../modules/auth/login_view.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';
import '../../modules/notification_settings/notification_settings_binding.dart';
import '../../modules/notification_settings/notification_settings_view.dart';
import '../../modules/paywall/paywall_binding.dart';
import '../../modules/paywall/paywall_view.dart';
import '../../modules/profile/profile_binding.dart';
import '../../modules/profile/profile_view.dart';
import '../../modules/report/report_binding.dart';
import '../../modules/report/report_view.dart';
import '../../modules/vehicle_detail/vehicle_detail_binding.dart';
import '../../modules/vehicle_detail/vehicle_detail_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.addVehicle,
      page: () => const AddVehicleView(),
      binding: AddVehicleBinding(),
    ),
    GetPage(
      name: AppRoutes.vehicleDetail,
      page: () => const VehicleDetailView(),
      binding: VehicleDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.addEvent,
      page: () => const AddEventView(),
      binding: AddEventBinding(),
    ),
    GetPage(
      name: AppRoutes.addReminder,
      page: () => const AddReminderView(),
      binding: AddReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.paywall,
      page: () => const PaywallView(),
      binding: PaywallBinding(),
    ),
    GetPage(
      name: AppRoutes.report,
      page: () => const ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.notificationSettings,
      page: () => const NotificationSettingsView(),
      binding: NotificationSettingsBinding(),
    ),
  ];
}