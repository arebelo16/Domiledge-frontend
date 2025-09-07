import 'package:flutter/material.dart';
import '../../account/model/user_profile.dart';
import 'section_card.dart';

class PersonalInfoCard extends StatefulWidget {
  final UserProfile profile;
  final Future<void> Function(UserProfile) onSaved;

  const PersonalInfoCard({
    super.key,
    required this.profile,
    required this.onSaved,
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
    final p = widget.profile;
    name = p.name;
    phone = p.phone ?? '';
    country = p.country ?? '';
    city = p.city ?? '';
    address = p.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.person_outline,
      title: 'Informação Pessoal',
      subtitle: 'Dados básicos e contactos.',
      child: Form(
        key: _form,
        child: Column(
          children: [
            _f('Nome', name, (v) => name = v ?? ''),
            const SizedBox(height: 10),
            _f('Telemóvel', phone, (v) => phone = v ?? ''),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _f('País', country, (v) => country = v ?? '')),
                const SizedBox(width: 10),
                Expanded(child: _f('Cidade', city, (v) => city = v ?? '')),
              ],
            ),
            const SizedBox(height: 10),
            _f('Morada', address, (v) => address = v ?? ''),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.save_rounded, size: 18),
                onPressed: () async {
                  _form.currentState?.save();
                  await widget.onSaved(
                    widget.profile.copyWith(
                      name: name,
                      phone: phone,
                      country: country,
                      city: city,
                      address: address,
                    ),
                  );
                },
                label: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _f(String label, String initial, FormFieldSetter<String> onSaved) {
    return TextFormField(
      initialValue: initial,
      onSaved: onSaved,
      decoration: const InputDecoration(
        labelText: '', // labels subtis (mantém o look atual)
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
