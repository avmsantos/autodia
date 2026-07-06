import 'package:disable_battery_optimization/disable_battery_optimization.dart';

/// Em fabricantes como Xiaomi (MIUI), Samsung, Huawei, etc., o Android
/// "padrão" não é suficiente — eles têm gerenciadores de bateria próprios
/// que matam processos em segundo plano agressivamente, o que pode impedir
/// notificações agendadas de disparar mesmo com todas as permissões do
/// Android concedidas.
///
/// Não existe API oficial do Android pra resolver isso — só dá pra pedir
/// pro usuário ajustar manualmente. Esse serviço só ajuda a mostrar o
/// caminho certo (a tela de configuração varia por fabricante).
class BatteryOptimizationService {
  /// true se AINDA falta alguma otimização a ajustar (bateria "nativa" do
  /// Android e/ou a específica do fabricante).
  Future<bool> precisaAjustar() async {
    final bateriaNativaDesativada =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled ?? false;
    final fabricanteDesativado =
        await DisableBatteryOptimization.isManufacturerBatteryOptimizationDisabled ??
            false;
    return !(bateriaNativaDesativada && fabricanteDesativado);
  }

  /// Mostra as telas de ajuste (nativa do Android + específica do
  /// fabricante, se existir uma pra esse aparelho). Não dá pra saber com
  /// certeza se o usuário concluiu — o próprio Android não expõe isso.
  Future<void> mostrarTelasDeAjuste() {
    return DisableBatteryOptimization.showDisableAllOptimizationsSettings(
      'Ativar início automático',
      'Isso garante que o app continue rodando em segundo plano pra '
          'avisar sobre manutenções vencendo.',
      'Desativar otimização de bateria',
      'Isso evita que o sistema feche o app e perca notificações agendadas.',
    );
  }
}