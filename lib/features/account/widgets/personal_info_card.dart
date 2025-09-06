import 'package:flutter/material.dart';
import '../../account/model/user_profile.dart';
import 'section_card.dart';

class PersonalInfoCard extends StatefulWidget {
  final UserProfile profile;
  final bool saving;
  final Future<void> Function(UserProfile) onSave;

  const PersonalInfoCard({
    super.key,
    required this.profile,
    required this.saving,
    required this.onSave,
  });

  @override
  State<PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<PersonalInfoCard> {
  final _form = GlobalKey<FormState>();
  late String name, phone, country, city, address;

  @override
  void initState() {
    super.initState();
    name = widget.profile.name;
    phone = widget.profile.phone ?? '';
    country = widget.profile.country ?? '';
    city = widget.profile.city ?? '';
    address = widget.profile.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Informação Pessoal',
      subtitle: 'Dados básicos e contactos.',
      child: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            _field('Nome', initial: name, onSaved: (v) => name = v!, validator: _req),
            _field('Telemóvel', initial: phone, onSaved: (v) => phone = v ?? ''),
            Row(
              children: [
                Expanded(child: _field('País', initial: country, onSaved: (v) => country = v ?? '')),
                const SizedBox(width: 12),
                Expanded(child: _field('Cidade', initial: city, onSaved: (v) => city = v ?? '')),
              ],
            ),
            _field('Morada', initial: address, onSaved: (v) => address = v ?? ''),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: widget.saving ? null : () async {
                  if (!_form.currentState!.validate()) return;
                  _form.currentState!.save();
                  await widget.onSave(widget.profile.copyWith(
                    name: name, phone: phone, country: country, city: city, address: address,
                  ));
                },
                icon: widget.saving
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null;

  Widget _field(String label, {String? initial, FormFieldSetter<String>? onSaved, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initial, validator: validator, onSaved: onSaved,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
