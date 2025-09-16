import 'package:flutter/material.dart';

class CreatePropertyResult {
  final String name;
  final String location;
  final String type;
  final double estimatedProfit;
  final int bookings;

  CreatePropertyResult({
    required this.name,
    required this.location,
    required this.type,
    required this.estimatedProfit,
    required this.bookings,
  });
}

class CreatePropertyDialog extends StatefulWidget {
  const CreatePropertyDialog({super.key});

  @override
  State<CreatePropertyDialog> createState() => _CreatePropertyDialogState();
}

class _CreatePropertyDialogState extends State<CreatePropertyDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _estimatedProfit = TextEditingController(text: '0');
  final _bookings = TextEditingController(text: '0');

  String _type = 'Apartamento';

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _estimatedProfit.dispose();
    _bookings.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    final profit =
        double.tryParse(_estimatedProfit.text.replaceAll(',', '.')) ?? 0;
    final book = int.tryParse(_bookings.text) ?? 0;

    Navigator.of(context).pop(
      CreatePropertyResult(
        name: _name.text.trim(),
        location: _location.text.trim(),
        type: _type,
        estimatedProfit: profit,
        bookings: book,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Propriedade'),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _location,
                decoration: const InputDecoration(labelText: 'Localização'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(
                    value: 'Apartamento',
                    child: Text('Apartamento'),
                  ),
                  DropdownMenuItem(value: 'Moradia', child: Text('Moradia')),
                  DropdownMenuItem(value: 'Estúdio', child: Text('Estúdio')),
                ],
                onChanged: (v) => setState(() => _type = v ?? _type),
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _estimatedProfit,
                decoration: const InputDecoration(
                  labelText: 'Lucro estimado (€)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bookings,
                decoration: const InputDecoration(labelText: 'Reservas (nº)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Criar')),
      ],
    );
  }
}
