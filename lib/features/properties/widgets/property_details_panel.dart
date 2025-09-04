import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../core/services/reservation_service.dart';
import 'property_calendar.dart';
import 'property_stats_chart.dart';
import 'property_edit_dialog.dart';

class PropertyDetailsPanel extends StatefulWidget {
  final String name;
  final String location;
  final int bookings;
  final double estimatedProfit;
  final String type;

  final void Function({
  required String name,
  required String location,
  required int bookings,
  required double estimatedProfit,
  required String type,
  })? onUpdate;

  final Future<bool> Function()? onDelete;

  const PropertyDetailsPanel({
    required this.name,
    required this.location,
    required this.bookings,
    required this.estimatedProfit,
    required this.type,
    this.onUpdate,
    this.onDelete,
    super.key,
  });

  @override
  State<PropertyDetailsPanel> createState() => _PropertyDetailsPanelState();
}

class _PropertyDetailsPanelState extends State<PropertyDetailsPanel> {
  final ScrollController _scrollController = ScrollController();
  bool _isHoveringGraph = false;

  // Estado local editável (para refletir alterações visualmente sem rebuild do parent)
  late String _name;
  late String _location;
  late int _bookings;
  late double _estimatedProfit;
  late String _type;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _location = widget.location;
    _bookings = widget.bookings;
    _estimatedProfit = widget.estimatedProfit;
    _type = widget.type;
  }

  Future<void> _openEditDialog() async {
    final res = await showDialog<PropertyEditResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PropertyEditDialog(
        initialName: _name,
        initialLocation: _location,
        initialBookings: _bookings,
        initialEstimatedProfit: _estimatedProfit,
        initialType: _type,
        onDeletePressed: () async {
          if (widget.onDelete != null) {
            final ok = await widget.onDelete!.call();
            return ok;
          }
          // fallback visual
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Delete callback não ligado')),
          );
          return false;
        },
      ),
    );

    if (res == null) return;

    if (res.deleted == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propriedade apagada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() {
      _name = res.name!;
      _location = res.location!;
      _bookings = res.bookings!;
      _estimatedProfit = res.estimatedProfit!;
      _type = res.type!;
    });

    widget.onUpdate?.call(
      name: _name,
      location: _location,
      bookings: _bookings,
      estimatedProfit: _estimatedProfit,
      type: _type,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Propriedade atualizada.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Listener(
      onPointerSignal: (event) {
        if (!isMobile && event is PointerScrollEvent && !_isHoveringGraph) {
          final newOffset = _scrollController.offset + event.scrollDelta.dy;
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              newOffset.clamp(
                _scrollController.position.minScrollExtent,
                _scrollController.position.maxScrollExtent,
              ),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: isMobile
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _infoRow('📍 Localização:', _location),
                        _infoRow('📅 Reservas este mês:', _bookings.toString()),
                        _infoRow('💸 Lucro estimado:',
                            '${_estimatedProfit.toStringAsFixed(2)}€'),
                        _infoRow('🏷️ Tipo:', _type),
                      ],
                    ),

                    const Divider(thickness: 1.5, color: Colors.blue),
                    const SizedBox(height: 12),

                    MouseRegion(
                      onEnter: (_) => setState(() => _isHoveringGraph = true),
                      onExit: (_) => setState(() => _isHoveringGraph = false),
                      child: SizedBox(
                        height: 200,
                        child: ProfitChart(
                          propertyKey: _name,
                          profitsProvider: MockProfitsProvider(), // ou Http...
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    _CalendarHeader(
                      title: 'Calendário de Reservas',
                      onManage: () {
                        // TODO - Gerir reservas
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('TODO - Gerir reservas'),
                          ),
                        );
                      },
                    ),

                    const Divider(thickness: 1.5, color: Colors.blue),
                    const SizedBox(height: 12),

                    PropertyCalendar(
                      propertyKey: _name,
                      reservationsProvider: MockReservationsProvider(), // ou Http...
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: _openEditDialog,
                icon: const Icon(Icons.edit),
                label: const Text('Editar Propriedade'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }
}

// ---------- HEADER DO CALENDÁRIO RESPONSIVO ----------
class _CalendarHeader extends StatelessWidget {
  final String title;
  final VoidCallback onManage;

  const _CalendarHeader({
    required this.title,
    required this.onManage,
  });

  Widget _manageButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onManage,
      icon: const Icon(Icons.calendar_month_outlined),
      label: const Text('Gerir reservas'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: Colors.blue.shade200),
        backgroundColor: Colors.white.withOpacity(0.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth;

        if (width >= 900) {
          final realButton = _manageButton(context);
          final ghostButton = Opacity(
            opacity: 0,
            child: IgnorePointer(child: _manageButton(context)),
          );

          return SizedBox(
            height: 40,
            child: Row(
              children: [
                ghostButton,
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                realButton,
              ],
            ),
          );
        }

        return Column(
          children: [
            Center(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(child: _manageButton(context)),
          ],
        );
      },
    );
  }
}
