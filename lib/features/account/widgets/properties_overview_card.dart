import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../properties/controllers/properties_controller.dart';
import 'section_card.dart';

class PropertiesOverviewCard extends StatefulWidget {
  final int limit;
  final bool dense;

  const PropertiesOverviewCard({super.key, this.limit = 5, this.dense = false});

  @override
  State<PropertiesOverviewCard> createState() => _PropertiesOverviewCardState();
}

class _PropertiesOverviewCardState extends State<PropertiesOverviewCard> {
  final _controller = PropertiesController();
  late Future<List<_Item>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_Item>> _load() async {
    final list = await _controller.fetchAll();
    return list
        .take(widget.limit)
        .map((e) => _Item(e.id, e.model.title, e.model.address, e.model.type))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      dense: widget.dense,
      icon: Icons.apartment,
      title: 'As tuas propriedades',
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed(AppRoutes.properties),
          child: const Text('Ver todas'),
        ),
      ],
      child: FutureBuilder<List<_Item>>(
        future: _future,
        builder: (context, s) {
          if (!s.hasData) return const LinearProgressIndicator();
          final list = s.data!;
          if (list.isEmpty) return const Text('Sem propriedades.');
          return Column(
            children: list.map((it) {
              return ListTile(
                dense: true,
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.home_work_outlined, size: 20),
                title: Text(
                  it.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${it.type} • ${it.address}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.properties,
                    arguments: {'selectedId': it.id},
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _Item {
  final String id, title, address, type;

  _Item(this.id, this.title, this.address, this.type);
}
