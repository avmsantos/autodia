import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  static const _mesesAbreviados = [
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos · ${controller.vehicle.nome}'),
        actions: [
          Obx(
            () => controller.isExporting.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.ios_share),
                    tooltip: 'Exportar',
                    onPressed: () => _mostrarOpcoesExportacao(context),
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _YearSelector(controller: controller),
            const SizedBox(height: 16),
            _TotalCard(controller: controller),
            const SizedBox(height: 24),
            Text('Gasto por mês', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: _MonthlyBarChart(controller: controller)),
            const SizedBox(height: 24),
            Text('Gasto por categoria', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _CategoryList(controller: controller),
          ],
        );
      }),
    );
  }

  Future<void> _mostrarOpcoesExportacao(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('Exportar como PDF'),
              onTap: () {
                Navigator.pop(context);
                controller.exportarPdf();
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Exportar como Excel'),
              onTap: () {
                Navigator.pop(context);
                controller.exportarExcel();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  final ReportController controller;
  const _YearSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<int>(
        value: controller.anoSelecionado.value,
        decoration: const InputDecoration(
          labelText: 'Ano',
          border: OutlineInputBorder(),
        ),
        items: controller.anosDisponiveis
            .map((ano) => DropdownMenuItem(value: ano, child: Text('$ano')))
            .toList(),
        onChanged: (ano) {
          if (ano != null) controller.selecionarAno(ano);
        },
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final ReportController controller;
  const _TotalCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total gasto em ${controller.anoSelecionado.value}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'R\$ ${controller.totalAno.value.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  final ReportController controller;
  const _MonthlyBarChart({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dados = controller.gastoPorMes;
      final maiorValor = dados.fold<double>(
        0,
        (max, g) => g.valor > max ? g.valor : max,
      );

      if (maiorValor == 0) {
        return const Center(child: Text('Sem gastos registrados nesse ano'));
      }

      return BarChart(
        BarChartData(
          maxY: maiorValor * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index > 11) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      ReportView._mesesAbreviados[index],
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(12, (i) {
            final valor = dados[i].valor;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: valor,
                  color: Theme.of(context).colorScheme.primary,
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      );
    });
  }
}

class _CategoryList extends StatelessWidget {
  final ReportController controller;
  const _CategoryList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lista = controller.gastoPorCategoria;
      if (lista.isEmpty) {
        return const Text('Sem gastos registrados nesse ano');
      }

      final maiorValor = lista.first.valor;

      return Column(
        children: lista.map((g) {
          final proporcao = maiorValor == 0 ? 0.0 : g.valor / maiorValor;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(g.nome),
                    Text(
                      'R\$ ${g.valor.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: proporcao,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}