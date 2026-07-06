// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter_timezone/flutter_timezone.dart';
// // import 'package:get/get.dart';
// // import 'package:timezone/data/latest.dart' as tz_data;
// // import 'package:timezone/timezone.dart' as tz;

// // import '../calculations/maintenance_calculator.dart';
// // import '../../data/local/app_database.dart';

// // /// Agenda e cancela notificações locais de vencimento de manutenção.
// // ///
// // /// Cada lembrete (Reminder) vira UMA notificação agendada, identificada por
// // /// um id numérico derivado do id (string/uuid) do lembrete no banco — o
// // /// plugin exige id inteiro, então convertemos de forma estável.
// // class NotificationService extends GetxService {
// //   final FlutterLocalNotificationsPlugin _plugin =
// //       FlutterLocalNotificationsPlugin();

// //   static const _channelId = 'lembretes_manutencao';
// //   static const _channelName = 'Lembretes de manutenção';

// //   Future<NotificationService> init() async {
// //     tz_data.initializeTimeZones();
// //     try {
// //       final localTimezone = await FlutterTimezone.getLocalTimezone();
// //       tz.setLocalLocation(tz.getLocation(localTimezone));
// //     } catch (_) {
// //       // Se não conseguir detectar, segue com UTC — não trava o app por isso,
// //       // só o horário exibido na notificação pode ficar levemente diferente.
// //     }

// //     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
// //     const initSettings = InitializationSettings(android: androidSettings);
// //     await _plugin.initialize(initSettings);

// //     final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
// //         AndroidFlutterLocalNotificationsPlugin>();
// //     await androidPlugin?.createNotificationChannel(
// //       const AndroidNotificationChannel(
// //         _channelId,
// //         _channelName,
// //         description: 'Avisos de manutenção próxima ou vencida',
// //         importance: Importance.high,
// //       ),
// //     );
// //     // Android 13+ exige essa permissão em runtime.
// //     await androidPlugin?.requestNotificationsPermission();
// //     // Necessário pra agendamento exato em Android 12+.
// //     await androidPlugin?.requestExactAlarmsPermission();

// //     return this;
// //   }

// //   int _notificationIdFor(String reminderId) =>
// //       reminderId.hashCode & 0x7FFFFFFF;

// //   /// Agenda (ou reagenda, se já existir) a notificação de um lembrete.
// //   /// Se `dueDate` já passou ou é null, não agenda nada.
// //   Future<void> scheduleReminderNotification({
// //     required String reminderId,
// //     required String vehicleName,
// //     required String categoryName,
// //     required DateTime? dueDate,
// //   }) async {
// //     final id = _notificationIdFor(reminderId);
// //     await _plugin.cancel(id);

// //     if (dueDate == null) return;

// //     // Agenda pras 9h da manhã do dia calculado. Se já passou, não agenda
// //     // (evita notificação "atrasada" disparando na hora errada) — o status
// //     // "Atrasado" já fica visível no app de qualquer forma.
// //     final scheduledDate = DateTime.now().add(const Duration(minutes: 1));
// //     if (scheduledDate.isBefore(DateTime.now())) return;

// //     await _plugin.zonedSchedule(
// //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
// //       id,
// //       '$categoryName · $vehicleName',
// //       'Está na hora de verificar essa manutenção.',
// //       tz.TZDateTime.from(scheduledDate, tz.local),
// //       const NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           _channelId,
// //           _channelName,
// //           importance: Importance.high,
// //           priority: Priority.high,
// //         ),
// //       ),
// //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //     );
// //   }

// //   Future<void> cancelReminderNotification(String reminderId) {
// //     return _plugin.cancel(_notificationIdFor(reminderId));
// //   }

// //   /// Recalcula e reagenda TODOS os lembretes ativos de um veículo.
// //   /// Chamar sempre que o km do veículo mudar (a estimativa de data dos
// //   /// lembretes por quilometragem depende disso) ou uma manutenção for
// //   /// registrada (o que também pode alterar o histórico usado na média).
// //   Future<void> rescheduleAllForVehicle(AppDatabase db, Vehicle vehicle) async {
// //     final reminders = await db.streamRemindersForVehicle(vehicle.id).first;
// //     if (reminders.isEmpty) return;

// //     final categories = await db.categoriesForType(vehicle.tipo);
// //     final categoriesById = {for (final c in categories) c.id: c};

// //     final kmHistoryRaw = await db.kmHistoryForVehicle(vehicle.id);
// //     final kmHistory =
// //         kmHistoryRaw.map((e) => KmHistoryPoint(date: e.$1, km: e.$2)).toList();

// //     for (final reminder in reminders) {
// //       final MaintenanceResult result;
// //       if (reminder.dataVencimentoManual != null) {
// //         result = calculateDateOnlyStatus(
// //           dueDate: reminder.dataVencimentoManual!,
// //           today: DateTime.now(),
// //         );
// //       } else {
// //         result = calculateMaintenanceStatus(
// //           MaintenanceInput(
// //             lastDoneDate: reminder.ultimaDataFeita,
// //             lastDoneKm: reminder.ultimoKmFeito,
// //             intervalMonths: reminder.intervaloMeses,
// //             intervalKm: reminder.intervaloKm,
// //             currentKm: vehicle.kmAtual,
// //             today: DateTime.now(),
// //             kmHistory: kmHistory,
// //           ),
// //         );
// //       }
// //       await scheduleReminderNotification(
// //         reminderId: reminder.id,
// //         vehicleName: vehicle.nome,
// //         categoryName: categoriesById[reminder.categoriaId]?.nome ?? 'Manutenção',
// //         dueDate: result.effectiveDueDate,
// //       );
// //     }
// //   }
// // }


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest.dart' as tz_data;
// import 'package:timezone/timezone.dart' as tz;

// import '../calculations/maintenance_calculator.dart';
// import '../../data/local/app_database.dart';

// /// Agenda e cancela notificações locais de vencimento de manutenção.
// ///
// /// Cada lembrete (Reminder) vira UMA notificação agendada, identificada por
// /// um id numérico derivado do id (string/uuid) do lembrete no banco — o
// /// plugin exige id inteiro, então convertemos de forma estável.
// class NotificationService extends GetxService {
//   final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();

//   static const _channelId = 'lembretes_manutencao';
//   static const _channelName = 'Lembretes de manutenção';

//   Future<NotificationService> init() async {
//     tz_data.initializeTimeZones();
//     try {
//       final localTimezone = await FlutterTimezone.getLocalTimezone();
//       tz.setLocalLocation(tz.getLocation(localTimezone));
//     } catch (_) {
//       // Se não conseguir detectar, segue com UTC — não trava o app por isso,
//       // só o horário exibido na notificação pode ficar levemente diferente.
//     }

//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);
//     await _plugin.initialize(initSettings);

//     final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//     await androidPlugin?.createNotificationChannel(
//       const AndroidNotificationChannel(
//         _channelId,
//         _channelName,
//         description: 'Avisos de manutenção próxima ou vencida',
//         importance: Importance.high,
//       ),
//     );
//     // Android 13+ exige essa permissão em runtime.
//     await androidPlugin?.requestNotificationsPermission();
//     // Necessário pra agendamento exato em Android 12+.
//     await androidPlugin?.requestExactAlarmsPermission();

//     return this;
//   }

//   int _notificationIdFor(String reminderId) =>
//       reminderId.hashCode & 0x7FFFFFFF;

//   /// Agenda (ou reagenda, se já existir) a notificação de um lembrete.
//   /// Se `dueDate` já passou ou é null, não agenda nada.
//   Future<void> scheduleReminderNotification({
//     required String reminderId,
//     required String vehicleName,
//     required String categoryName,
//     required DateTime? dueDate,
//   }) async {
//     final id = _notificationIdFor(reminderId);
//     await _plugin.cancel(id);

//     if (dueDate == null) return;

//     // Agenda pras 9h da manhã do dia calculado. Se já passou, não agenda
//     // (evita notificação "atrasada" disparando na hora errada) — o status
//     // "Atrasado" já fica visível no app de qualquer forma.
//     final scheduledDate = DateTime(
//       dueDate.year,
//       dueDate.month,
//       dueDate.day,
//       9,
//     );
//     if (scheduledDate.isBefore(DateTime.now())) return;

//     await _plugin.zonedSchedule(
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       id,
//       '$categoryName · $vehicleName',
//       'Está na hora de verificar essa manutenção.',
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channelId,
//           _channelName,
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   Future<void> cancelReminderNotification(String reminderId) {
//     return _plugin.cancel(_notificationIdFor(reminderId));
//   }

//   /// TEMPORÁRIO — só pra debug. Dispara uma notificação imediata, sem
//   /// agendamento nenhum. Se essa não aparecer, o problema é canal/permissão;
//   /// se aparecer mas a agendada não, o problema é o `zonedSchedule`
//   /// (geralmente falta de permissão de alarme exato).
//   Future<void> testarNotificacaoImediata() async {
//     await _plugin.show(
//       999999,
//       'Teste',
//       'Se você está vendo isso, o canal e a permissão estão OK.',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channelId,
//           _channelName,
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//     );
//   }

//   /// Recalcula e reagenda TODOS os lembretes ativos de um veículo.
//   /// Chamar sempre que o km do veículo mudar (a estimativa de data dos
//   /// lembretes por quilometragem depende disso) ou uma manutenção for
//   /// registrada (o que também pode alterar o histórico usado na média).
//   Future<void> rescheduleAllForVehicle(AppDatabase db, Vehicle vehicle) async {
//     final reminders = await db.streamRemindersForVehicle(vehicle.id).first;
//     if (reminders.isEmpty) return;

//     final categories = await db.categoriesForType(vehicle.tipo);
//     final categoriesById = {for (final c in categories) c.id: c};

//     final kmHistoryRaw = await db.kmHistoryForVehicle(vehicle.id);
//     final kmHistory =
//         kmHistoryRaw.map((e) => KmHistoryPoint(date: e.$1, km: e.$2)).toList();

//     for (final reminder in reminders) {
//       final MaintenanceResult result;
//       if (reminder.dataVencimentoManual != null) {
//         result = calculateDateOnlyStatus(
//           dueDate: reminder.dataVencimentoManual!,
//           today: DateTime.now(),
//         );
//       } else {
//         result = calculateMaintenanceStatus(
//           MaintenanceInput(
//             lastDoneDate: reminder.ultimaDataFeita,
//             lastDoneKm: reminder.ultimoKmFeito,
//             intervalMonths: reminder.intervaloMeses,
//             intervalKm: reminder.intervaloKm,
//             currentKm: vehicle.kmAtual,
//             today: DateTime.now(),
//             kmHistory: kmHistory,
//           ),
//         );
//       }
//       await scheduleReminderNotification(
//         reminderId: reminder.id,
//         vehicleName: vehicle.nome,
//         categoryName: categoriesById[reminder.categoriaId]?.nome ?? 'Manutenção',
//         dueDate: result.effectiveDueDate,
//       );
//     }
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../calculations/maintenance_calculator.dart';
import '../../data/local/app_database.dart';

/// Agenda e cancela notificações locais de vencimento de manutenção.
///
/// Cada lembrete (Reminder) vira UMA notificação agendada, identificada por
/// um id numérico derivado do id (string/uuid) do lembrete no banco — o
/// plugin exige id inteiro, então convertemos de forma estável.
class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'lembretes_manutencao';
  static const _channelName = 'Lembretes de manutenção';

  Future<NotificationService> init() async {
    tz_data.initializeTimeZones();
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone));
    } catch (_) {
      // Se não conseguir detectar, segue com UTC — não trava o app por isso,
      // só o horário exibido na notificação pode ficar levemente diferente.
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Avisos de manutenção próxima ou vencida',
        importance: Importance.high,
      ),
    );
    // Android 13+ exige essa permissão em runtime.
    await androidPlugin?.requestNotificationsPermission();
    // Necessário pra agendamento exato em Android 12+.
    await androidPlugin?.requestExactAlarmsPermission();

    return this;
  }

  int _notificationIdFor(String reminderId) =>
      reminderId.hashCode & 0x7FFFFFFF;

  /// Agenda (ou reagenda, se já existir) a notificação de um lembrete.
  /// Se `dueDate` já passou ou é null, não agenda nada.
  Future<void> scheduleReminderNotification({
    required String reminderId,
    required String vehicleName,
    required String categoryName,
    required DateTime? dueDate,
  }) async {
    final id = _notificationIdFor(reminderId);
    await _plugin.cancel(id);

    if (dueDate == null) {
      debugPrint('[Notificação] $categoryName · $vehicleName: sem dueDate, não agenda.');
      return;
    }

    // Agenda pras 9h da manhã do dia calculado. Se já passou, não agenda
    // (evita notificação "atrasada" disparando na hora errada) — o status
    // "Atrasado" já fica visível no app de qualquer forma.
    final scheduledDate = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      9,
    );
    debugPrint(
      '[Notificação] $categoryName · $vehicleName: dueDate=$dueDate, '
      'scheduledDate=$scheduledDate, agora=${DateTime.now()}',
    );
    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('[Notificação] scheduledDate já passou, não agenda.');
      return;
    }

    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);
    debugPrint('[Notificação] Agendando de verdade para $tzScheduled (tz.local=${tz.local})');

    await _plugin.zonedSchedule(
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      id,
      '$categoryName · $vehicleName',
      'Está na hora de verificar essa manutenção.',
      tzScheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminderNotification(String reminderId) {
    return _plugin.cancel(_notificationIdFor(reminderId));
  }

  /// TEMPORÁRIO — só pra debug. Dispara uma notificação imediata, sem
  /// agendamento nenhum. Se essa não aparecer, o problema é canal/permissão;
  /// se aparecer mas a agendada não, o problema é o `zonedSchedule`
  /// (geralmente falta de permissão de alarme exato).
  Future<void> testarNotificacaoImediata() async {
    await _plugin.show(
      999999,
      'Teste',
      'Se você está vendo isso, o canal e a permissão estão OK.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<bool> checkExactAlarmPermission() async {
  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  
  // Retorna true se a permissão já foi concedida
  return await androidPlugin?.canScheduleExactNotifications() ?? false;
}

  /// Recalcula e reagenda TODOS os lembretes ativos de um veículo.
  /// Chamar sempre que o km do veículo mudar (a estimativa de data dos
  /// lembretes por quilometragem depende disso) ou uma manutenção for
  /// registrada (o que também pode alterar o histórico usado na média).
  Future<void> rescheduleAllForVehicle(AppDatabase db, Vehicle vehicle) async {
    final reminders = await db.streamRemindersForVehicle(vehicle.id).first;
    if (reminders.isEmpty) return;

    final categories = await db.categoriesForType(vehicle.tipo);
    final categoriesById = {for (final c in categories) c.id: c};

    final kmHistoryRaw = await db.kmHistoryForVehicle(vehicle.id);
    final kmHistory =
        kmHistoryRaw.map((e) => KmHistoryPoint(date: e.$1, km: e.$2)).toList();

    for (final reminder in reminders) {
      final MaintenanceResult result;
      if (reminder.dataVencimentoManual != null) {
        result = calculateDateOnlyStatus(
          dueDate: reminder.dataVencimentoManual!,
          today: DateTime.now(),
        );
      } else {
        result = calculateMaintenanceStatus(
          MaintenanceInput(
            lastDoneDate: reminder.ultimaDataFeita,
            lastDoneKm: reminder.ultimoKmFeito,
            intervalMonths: reminder.intervaloMeses,
            intervalKm: reminder.intervaloKm,
            currentKm: vehicle.kmAtual,
            today: DateTime.now(),
            kmHistory: kmHistory,
          ),
        );
      }
      await scheduleReminderNotification(
        reminderId: reminder.id,
        vehicleName: vehicle.nome,
        categoryName: categoriesById[reminder.categoriaId]?.nome ?? 'Manutenção',
        dueDate: result.effectiveDueDate,
      );
    }
  }
}