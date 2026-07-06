/// Núcleo do diferencial do app: calcula quando uma manutenção vence,
/// considerando data, quilometragem, ou as duas coisas (o que vencer primeiro).
///
/// Este arquivo é lógica pura (sem Flutter, sem banco) de propósito:
/// dá pra testar isoladamente e reaproveitar em qualquer camada
/// (controller, worker de notificação, etc).
library maintenance_calculator;

/// Qual gatilho vai definir o vencimento de um lembrete.
enum TriggerType { date, km, both }

/// Situação atual de um lembrete, já traduzida pra UI.
enum MaintenanceStatus { emDia, proximo, atrasado }

/// Dados de entrada pro cálculo. Tudo que o app já tem salvo no banco.
class MaintenanceInput {
  /// Data em que a manutenção foi feita pela última vez (ou data de cadastro,
  /// se for a primeira vez que o usuário está configurando o lembrete).
  final DateTime lastDoneDate;

  /// Km do veículo na última vez que a manutenção foi feita.
  /// Pode ser null se o lembrete for só por data (ex: seguro, IPVA).
  final int? lastDoneKm;

  /// A cada quantos meses essa manutenção deve se repetir. Null se for só por km.
  final int? intervalMonths;

  /// A cada quantos km essa manutenção deve se repetir. Null se for só por data.
  final int? intervalKm;

  /// Km atual do veículo (o valor mais recente que o usuário informou).
  final int currentKm;

  /// Data de hoje (parâmetro explícito pra facilitar teste, em vez de usar
  /// DateTime.now() direto dentro da função).
  final DateTime today;

  /// Histórico de quilometragem informada pelo usuário ao longo do tempo,
  /// usado pra estimar a média de km rodados por dia. Precisa de pelo menos
  /// 2 pontos pra gerar estimativa; sem isso, cai num valor padrão.
  final List<KmHistoryPoint> kmHistory;

  const MaintenanceInput({
    required this.lastDoneDate,
    this.lastDoneKm,
    this.intervalMonths,
    this.intervalKm,
    required this.currentKm,
    required this.today,
    this.kmHistory = const [],
  })  : assert(
          intervalMonths != null || intervalKm != null,
          'Informe pelo menos um intervalo: por meses ou por km.',
        );

  TriggerType get triggerType {
    if (intervalMonths != null && intervalKm != null) return TriggerType.both;
    if (intervalKm != null) return TriggerType.km;
    return TriggerType.date;
  }
}

/// Um ponto de "usuário atualizou o km do veículo em tal data".
/// Usado só pra estimar a média diária de uso do veículo.
class KmHistoryPoint {
  final DateTime date;
  final int km;
  const KmHistoryPoint({required this.date, required this.km});
}

/// Resultado do cálculo, já pronto pra UI e pra agendar notificação.
class MaintenanceResult {
  /// Data em que a manutenção vence pela regra de tempo (null se for só por km).
  final DateTime? nextDueDateByDate;

  /// Km em que a manutenção vence pela regra de quilometragem (null se for só por data).
  final int? nextDueKm;

  /// Data estimada em que o km de vencimento deve ser atingido, com base na
  /// média de uso do veículo. Usada pra agendar notificação local mesmo
  /// quando o gatilho é só por km (já que notificação local precisa de uma data).
  final DateTime? estimatedDateForKmTrigger;

  /// A data final considerada pro cálculo de status — a mais próxima entre
  /// nextDueDateByDate e estimatedDateForKmTrigger, conforme o triggerType.
  final DateTime? effectiveDueDate;

  final TriggerType triggerType;
  final MaintenanceStatus status;

  /// Quantos km faltam pro vencimento por km (negativo se já passou).
  final int? kmRemaining;

  /// Quantos dias faltam pro vencimento efetivo (negativo se já passou).
  final int? daysRemaining;

  const MaintenanceResult({
    this.nextDueDateByDate,
    this.nextDueKm,
    this.estimatedDateForKmTrigger,
    this.effectiveDueDate,
    required this.triggerType,
    required this.status,
    this.kmRemaining,
    this.daysRemaining,
  });
}

/// Quantos km por dia, em média, o veículo roda — calculado a partir do
/// histórico de atualizações de quilometragem informadas pelo usuário.
///
/// Se não houver histórico suficiente (menos de 2 pontos), retorna um valor
/// padrão conservador de 30km/dia (~900km/mês, uso urbano comum no Brasil).
double estimateAverageKmPerDay(List<KmHistoryPoint> history) {
  if (history.length < 2) return 30.0;

  final sorted = [...history]..sort((a, b) => a.date.compareTo(b.date));
  final first = sorted.first;
  final last = sorted.last;

  final totalDays = last.date.difference(first.date).inDays;
  final totalKm = last.km - first.km;

  if (totalDays <= 0 || totalKm <= 0) return 30.0;

  return totalKm / totalDays;
}

/// Função principal: calcula o status completo de um lembrete de manutenção.
MaintenanceResult calculateMaintenanceStatus(MaintenanceInput input) {
  final triggerType = input.triggerType;

  DateTime? nextDueDateByDate;
  if (input.intervalMonths != null) {
    nextDueDateByDate = _addMonths(input.lastDoneDate, input.intervalMonths!);
  }

  int? nextDueKm;
  if (input.intervalKm != null) {
    final baseKm = input.lastDoneKm ?? input.currentKm;
    nextDueKm = baseKm + input.intervalKm!;
  }

  // Se o gatilho envolve km, estima em que data esse km deve ser atingido,
  // com base na média de uso — assim dá pra agendar notificação local
  // mesmo pra lembretes que são, na prática, "por quilometragem".
  DateTime? estimatedDateForKmTrigger;
  int? kmRemaining;
  if (nextDueKm != null) {
    kmRemaining = nextDueKm - input.currentKm;
    final avgKmPerDay = estimateAverageKmPerDay(input.kmHistory);
    final daysUntilKm = kmRemaining / avgKmPerDay;
    estimatedDateForKmTrigger = input.today.add(
      Duration(days: daysUntilKm.ceil()),
    );
  }

  // Data efetiva: a que vence primeiro, conforme o tipo de gatilho.
  DateTime? effectiveDueDate;
  switch (triggerType) {
    case TriggerType.date:
      effectiveDueDate = nextDueDateByDate;
      break;
    case TriggerType.km:
      effectiveDueDate = estimatedDateForKmTrigger;
      break;
    case TriggerType.both:
      if (nextDueDateByDate != null && estimatedDateForKmTrigger != null) {
        effectiveDueDate = nextDueDateByDate.isBefore(estimatedDateForKmTrigger)
            ? nextDueDateByDate
            : estimatedDateForKmTrigger;
      } else {
        effectiveDueDate = nextDueDateByDate ?? estimatedDateForKmTrigger;
      }
      break;
  }

  final daysRemaining = effectiveDueDate != null
      ? effectiveDueDate.difference(input.today).inDays
      : null;

  final status = _resolveStatus(
    daysRemaining: daysRemaining,
    kmRemaining: kmRemaining,
  );

  return MaintenanceResult(
    nextDueDateByDate: nextDueDateByDate,
    nextDueKm: nextDueKm,
    estimatedDateForKmTrigger: estimatedDateForKmTrigger,
    effectiveDueDate: effectiveDueDate,
    triggerType: triggerType,
    status: status,
    kmRemaining: kmRemaining,
    daysRemaining: daysRemaining,
  );
}

/// Regras de corte pra status. Ajustável conforme feedback de uso real:
/// - atrasado: já passou da data OU do km
/// - próximo: faltam 30 dias ou menos, OU 500km ou menos
/// - em dia: fora dessas janelas
MaintenanceStatus _resolveStatus({int? daysRemaining, int? kmRemaining}) {
  final bool overdueByDate = daysRemaining != null && daysRemaining < 0;
  final bool overdueByKm = kmRemaining != null && kmRemaining < 0;
  if (overdueByDate || overdueByKm) return MaintenanceStatus.atrasado;

  final bool soonByDate = daysRemaining != null && daysRemaining <= 30;
  final bool soonByKm = kmRemaining != null && kmRemaining <= 500;
  if (soonByDate || soonByKm) return MaintenanceStatus.proximo;

  return MaintenanceStatus.emDia;
}

/// Versão simplificada do cálculo, usada por categorias tipo `calendario`
/// (IPVA, seguro, licenciamento) — não envolve km, só a data de vencimento
/// que o usuário já informou diretamente.
MaintenanceResult calculateDateOnlyStatus({
  required DateTime dueDate,
  required DateTime today,
}) {
  final daysRemaining = dueDate.difference(today).inDays;
  return MaintenanceResult(
    nextDueDateByDate: dueDate,
    effectiveDueDate: dueDate,
    triggerType: TriggerType.date,
    status: _resolveStatus(daysRemaining: daysRemaining, kmRemaining: null),
    daysRemaining: daysRemaining,
  );
}

DateTime _addMonths(DateTime date, int months) {
  final totalMonths = date.month + months;
  final year = date.year + (totalMonths - 1) ~/ 12;
  final month = ((totalMonths - 1) % 12) + 1;
  // Evita erro em meses com menos dias (ex: 31/jan + 1 mês -> 28/fev)
  final lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
  final day = date.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : date.day;
  return DateTime(year, month, day, date.hour, date.minute);
}
