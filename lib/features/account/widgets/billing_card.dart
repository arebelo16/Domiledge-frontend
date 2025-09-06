import 'package:flutter/material.dart';
import 'section_card.dart';

class BillingCard extends StatefulWidget {
  final String plan;
  final String? vat;
  final String? company;
  final bool saving;
  final Future<void> Function(String? vat, String? company) onSave;

  const BillingCard({
    super.key,
    required this.plan,
    required this.vat,
    required this.company,
    required this.saving,
    required this.onSave,
  });

  @override
  State<BillingCard> createState() => _BillingCardState();
}

class _BillingCardState extends State<BillingCard> {
  late String vat, company;

  @override
  void initState() {
    super.initState();
    vat = widget.vat ?? '';
    company = widget.company ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Faturação & Plano',
      subtitle: 'Dados para faturação e recibos.',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextFormField(
                initialValue: vat, onChanged: (v) => vat = v,
                decoration: const InputDecoration(labelText: 'NIF/VAT', border: OutlineInputBorder()),
              )),
              const SizedBox(width: 12),
              Expanded(child: TextFormField(
                initialValue: company, onChanged: (v) => company = v,
                decoration: const InputDecoration(labelText: 'Empresa', border: OutlineInputBorder()),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: widget.saving ? null : () => widget.onSave(vat, company),
              icon: widget.saving
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
