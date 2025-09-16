import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PropertyEditResult {
  final String? name;
  final String? location;
  final int? bookings;
  final double? estimatedProfit;
  final String? type;
  final bool deleted;

  PropertyEditResult({
    this.name,
    this.location,
    this.bookings,
    this.estimatedProfit,
    this.type,
    this.deleted = false,
  });
}

class PropertyEditDialog extends StatefulWidget {
  final String initialName;
  final String initialLocation;
  final int initialBookings;
  final double initialEstimatedProfit;
  final String? initialType;
  final Future<bool> Function() onDeletePressed;

  const PropertyEditDialog({
    super.key,
    required this.initialName,
    required this.initialLocation,
    required this.initialBookings,
    required this.initialEstimatedProfit,
    required this.initialType,
    required this.onDeletePressed,
  });

  @override
  State<PropertyEditDialog> createState() => _PropertyEditDialogState();
}

class _PropertyEditDialogState extends State<PropertyEditDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _bookingsCtrl;
  late final TextEditingController _profitCtrl;

  static const List<String> _defaultTypes = [
    'Apartamento',
    'Moradia',
    'Quarto',
    'Estúdio',
  ];

  String? _type;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _locationCtrl = TextEditingController(text: widget.initialLocation);
    _bookingsCtrl = TextEditingController(
      text: widget.initialBookings.toString(),
    );
    _profitCtrl = TextEditingController(
      text: widget.initialEstimatedProfit.toStringAsFixed(2),
    );

    final t = (widget.initialType ?? '').trim();
    _type = t.isEmpty
        ? null
        : _defaultTypes.firstWhere(
            (x) => x.toLowerCase() == t.toLowerCase(),
            orElse: () => t,
          );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _bookingsCtrl.dispose();
    _profitCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Apagar propriedade'),
        content: const Text(
          'Tens a certeza que queres apagar esta propriedade? Esta ação é permanente.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.delete_forever),
            label: const Text('Apagar'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.12),
              foregroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (ok == true) {
      final deleted = await widget.onDeletePressed();
      if (deleted && mounted) {
        Navigator.of(context).pop(PropertyEditResult(deleted: true));
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final bookings = int.tryParse(_bookingsCtrl.text.trim()) ?? 0;
    final profit =
        double.tryParse(_profitCtrl.text.replaceAll(',', '.').trim()) ?? 0;

    Navigator.of(context).pop(
      PropertyEditResult(
        name: _nameCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
        bookings: bookings,
        estimatedProfit: profit,
        type: _type?.trim() ?? '',
        deleted: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 720;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------- HEADER ----------
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.home_work,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Editar Propriedade',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Fechar',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),

              const SizedBox(height: 16),

              // ---------- FORM ----------
              Form(
                key: _formKey,
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _leftForm()),
                          const SizedBox(width: 16),
                          Expanded(child: _rightForm()),
                        ],
                      )
                    : Column(
                        children: [
                          _leftForm(),
                          const SizedBox(height: 16),
                          _rightForm(),
                        ],
                      ),
              ),

              const SizedBox(height: 20),

              // ---------- ACTIONS ----------
              Row(
                children: [
                  isMobile
                      ? IconButton(
                          tooltip: 'Apagar propriedade',
                          onPressed: _confirmDelete,
                          icon: const Icon(Icons.delete, color: Colors.red),
                        )
                      : TextButton.icon(
                          onPressed: _confirmDelete,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Apagar propriedade'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                          ),
                        ),

                  const Spacer(),

                  isMobile
                      ? IconButton(
                          tooltip: 'Cancelar',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        )
                      : OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),

                  const SizedBox(width: 8),

                  isMobile
                      ? IconButton(
                          tooltip: 'Guardar alterações',
                          onPressed: _save,
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Colors.blueAccent,
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Guardar alterações'),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- CAMPOS ESQUERDA ----------
  Widget _leftForm() {
    return Column(
      children: [
        TextFormField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nome',
            hintText: 'Ex.: Casa Vela',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _locationCtrl,
          decoration: const InputDecoration(
            labelText: 'Localização',
            hintText: 'Ex.: Lisboa, Portugal',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
        ),
      ],
    );
  }

  // ---------- CAMPOS DIREITA ----------
  Widget _rightForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _bookingsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reservas (mês)',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 0) return 'Número inválido';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _profitCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lucro estimado (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                validator: (v) {
                  final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                  if (n == null) return 'Valor inválido';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: _mapValueToItem(_type),
          decoration: const InputDecoration(
            labelText: 'Tipo (opcional)',
            border: OutlineInputBorder(),
          ),
          hint: const Text('(Sem tipo)'),
          items: [
            ..._defaultTypes.map(
              (t) => DropdownMenuItem<String>(value: t, child: Text(t)),
            ),
            if (_type != null &&
                !_defaultTypes.any(
                  (t) => t.toLowerCase() == _type!.toLowerCase(),
                ))
              DropdownMenuItem<String>(value: _type, child: Text(_type!)),
          ],
          onChanged: (v) => setState(() => _type = v),
        ),
      ],
    );
  }

  String? _mapValueToItem(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    for (final item in _defaultTypes) {
      if (item.toLowerCase() == v.toLowerCase()) return item;
    }
    return v; // custom
  }
}
