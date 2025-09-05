import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/models/profits_model.dart';
import '../../../core/services/reservation_service.dart' show ProfitsProvider;

class ProfitChart extends StatefulWidget {
  const ProfitChart({
    super.key,
    required this.propertyKey,
    this.series,
    this.profitsProvider,
  });

  final String propertyKey;
  final List<ProfitPoint>? series;
  final ProfitsProvider? profitsProvider;

  @override
  State<ProfitChart> createState() => _ProfitChartState();
}

class _ProfitChartState extends State<ProfitChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late DateTimeAxis _xAxis;
  late NumericAxis _yAxis;

  List<ProfitPoint> _data = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _xAxis = DateTimeAxis(
      enableAutoIntervalOnZooming: true,
      dateFormat: DateFormat.MMM(),
      intervalType: DateTimeIntervalType.months,
      minimum: DateTime(2023, 1),
      maximum: DateTime(2025, 12),
      majorGridLines: const MajorGridLines(width: 0),
    );

    _yAxis = NumericAxis(
      enableAutoIntervalOnZooming: true,
      minimum: -6000,
      maximum: 6000,
      labelFormat: '{value}€',
      axisLine: const AxisLine(width: 1),
      majorGridLines: const MajorGridLines(width: 0.5),
    );

    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      enableMouseWheelZooming: true,
      zoomMode: ZoomMode.xy,
    );

    _loadSeries();
  }

  @override
  void didUpdateWidget(covariant ProfitChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.propertyKey != widget.propertyKey ||
        oldWidget.series != widget.series ||
        oldWidget.profitsProvider != widget.profitsProvider) {
      _loadSeries();
    }
  }

  Future<void> _loadSeries() async {
    setState(() => _loading = true);

    if (widget.series != null) {
      _data = List.of(widget.series!)
        ..sort((a, b) => a.x.compareTo(b.x));
      setState(() => _loading = false);
      return;
    }

    if (widget.profitsProvider != null) {
      try {
        final points = await widget.profitsProvider!.fetchSeries(widget.propertyKey);
        _data = List.of(points)..sort((a, b) => a.x.compareTo(b.x));
      } catch (_) {
        _data = _fallbackData();
      }
      setState(() => _loading = false);
      return;
    }

    _data = _fallbackData();
    setState(() => _loading = false);
  }

  List<ProfitPoint> _fallbackData() => <ProfitPoint>[
    ProfitPoint(DateTime(2023, 1), -5400),
    ProfitPoint(DateTime(2023, 3), -2580),
    ProfitPoint(DateTime(2023, 5), -1110),
    ProfitPoint(DateTime(2023, 6), 50),
    ProfitPoint(DateTime(2023, 7), 600),
    ProfitPoint(DateTime(2023, 10), -200),
    ProfitPoint(DateTime(2024, 1), 900),
    ProfitPoint(DateTime(2024, 5), 700),
    ProfitPoint(DateTime(2024, 8), -100),
    ProfitPoint(DateTime(2024, 9), 910),
    ProfitPoint(DateTime(2025, 2), 1910),
    ProfitPoint(DateTime(2025, 6), 210),
    ProfitPoint(DateTime(2025, 12), 4910),
  ];

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {},
      behavior: HitTestBehavior.opaque,
      child: SfCartesianChart(
        primaryXAxis: _xAxis,
        primaryYAxis: _yAxis,
        plotAreaBorderWidth: 0,
        zoomPanBehavior: _zoomPanBehavior,
        tooltipBehavior: TooltipBehavior(enable: true),
        title: ChartTitle(
          text: 'Lucros Recentes',
          alignment: ChartAlignment.center,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        series: _buildSegmentedSeries(_data),
      ),
    );
  }

  List<LineSeries<ProfitPoint, DateTime>> _buildSegmentedSeries(
      List<ProfitPoint> data) {
    if (data.length < 2) return const [];

    final List<LineSeries<ProfitPoint, DateTime>> segments = [];

    for (int i = 0; i < data.length - 1; i++) {
      final p1 = data[i];
      final p2 = data[i + 1];
      Color color;

      if ((p1.y < 0 && p2.y >= 0) || (p1.y >= 0 && p2.y < 0)) {
        color = Colors.amber;
      } else if (p1.y < 0 && p2.y < 0) {
        color = Colors.red;
      } else {
        color = Colors.green;
      }

      segments.add(
        LineSeries<ProfitPoint, DateTime>(
          dataSource: [p1, p2],
          xValueMapper: (p, _) => p.x,
          yValueMapper: (p, _) => p.y,
          color: color,
          width: 3,
          markerSettings: const MarkerSettings(isVisible: false),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
      );
    }

    return segments;
  }
}
