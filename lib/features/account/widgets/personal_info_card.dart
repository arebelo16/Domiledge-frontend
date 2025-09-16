import 'package:flutter/material.dart';

import '../../../shared/widgets/text_fields.dart';
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

  late final TextEditingController _nameC;
  late final TextEditingController _phoneC;
  late final TextEditingController _countryC;
  late final TextEditingController _cityC;
  late final TextEditingController _addressC;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameC = TextEditingController(text: p.name);
    _phoneC = TextEditingController(text: p.phone ?? '');
    _countryC = TextEditingController(text: p.country ?? '');
    _cityC = TextEditingController(text: p.city ?? '');
    _addressC = TextEditingController(text: p.address ?? '');
  }

  @override
  void dispose() {
    _nameC.dispose();
    _phoneC.dispose();
    _countryC.dispose();
    _cityC.dispose();
    _addressC.dispose();
    super.dispose();
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
            CustomTextField(
              controller: _nameC,
              label: 'Nome',
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _phoneC,
              label: 'Telemóvel',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _countryC,
                    label: 'País',
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.countryName],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _cityC,
                    label: 'Cidade',
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.addressCity],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: _addressC,
              label: 'Morada',
              maxLines: 2,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.fullStreetAddress],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                icon: const Icon(Icons.save_rounded, size: 18),
                onPressed: () async {
                  await widget.onSaved(
                    widget.profile.copyWith(
                      name: _nameC.text.trim(),
                      phone: _phoneC.text.trim().isEmpty
                          ? null
                          : _phoneC.text.trim(),
                      country: _countryC.text.trim().isEmpty
                          ? null
                          : _countryC.text.trim(),
                      city: _cityC.text.trim().isEmpty
                          ? null
                          : _cityC.text.trim(),
                      address: _addressC.text.trim().isEmpty
                          ? null
                          : _addressC.text.trim(),
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
}
