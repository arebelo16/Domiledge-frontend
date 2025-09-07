import 'package:flutter/material.dart';
import 'section_card.dart';

class BillingCard extends StatefulWidget {
  final String plan;
  final String? vat;
  final String? company;
  final Future<void> Function(String? vat, String? company) onSave;
  final bool dense;

  const BillingCard({
    super.key,
    required this.plan,
    required this.vat,
    required this.company,
    required this.onSave,
    this.dense = false,
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
      dense: widget.dense,
      icon: Icons.receipt_long_outlined,
      title: 'Faturação & Plano',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: vat,
                  onChanged: (v) => vat = v,
                  decoration: const InputDecoration(
                    labelText: 'NIF/VAT',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: company,
                  onChanged: (v) => company = v,
                  decoration: const InputDecoration(
                    labelText: 'Empresa',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              icon: const Icon(Icons.save_rounded, size: 18),
              onPressed: () => widget.onSave(vat, company),
              label: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }
}
