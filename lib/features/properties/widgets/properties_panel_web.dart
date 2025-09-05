import 'package:flutter/material.dart';

import '../../../core/models/property_model.dart';
import '../controllers/properties_controller.dart';
import '../widgets/add_property_button.dart';
import '../widgets/create_property_dialog.dart';
import '../widgets/properties_grid.dart';
import '../widgets/property_details_panel.dart';

class PropertiesPanelWeb extends StatefulWidget {
  const PropertiesPanelWeb({super.key});

  @override
  State<PropertiesPanelWeb> createState() => _PropertiesPanelWebState();
}

class _PropertiesPanelWebState extends State<PropertiesPanelWeb> {
  final _controller = PropertiesController();

  List<PropertyItem> _items = [];
  PropertyItem? _selected;

  final Map<String, int> _rankById = <String, int>{};
  int _rankCounter = 0;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _controller.fetchAll();

      for (final it in list) {
        _rankById.putIfAbsent(it.id, () => _rankCounter++);
      }

      list.sort((a, b) => (_rankById[a.id]! ).compareTo(_rankById[b.id]! ));

      setState(() {
        _items = list;
        _selected ??= _items.isNotEmpty ? _items.first : null;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = 'Erro ao carregar propriedades';
      });
    }
  }

  // ------------------- CREATE -------------------
  Future<void> _onAddPropertyPressed() async {
    final res = await showDialog<CreatePropertyResult>(
      context: context,
      builder: (_) => const CreatePropertyDialog(),
    );
    if (res == null) return;

    try {
      final created = await _controller.create(
        title: res.name,
        address: res.location,
        type: res.type,
        estimatedProfit: res.estimatedProfit,
        bookings: res.bookings,
      );

      setState(() {
        _rankById.putIfAbsent(created.id, () => _rankCounter++);
        _items = [..._items, created]..sort(
              (a, b) => (_rankById[a.id]! ).compareTo(_rankById[b.id]! ),
        );
        _selected = created;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propriedade criada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro a criar: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ------------------- UPDATE -------------------
  Future<void> _updateProperty({
    required PropertyItem current,
    required String name,
    required String location,
    required int bookings,
    required double estimatedProfit,
    required String type,
  }) async {
    try {
      final updated = await _controller.update(
        current.id,
        PropertyModel(
          title: name,
          address: location,
          bookings: bookings,
          estimatedProfit: estimatedProfit,
          type: type,
        ),
      );

      setState(() {
        final idx = _items.indexWhere((e) => e.id == current.id);
        if (idx != -1) {
          final rank = _rankById[current.id] ?? _rankCounter++;
          _rankById[updated.id] = rank;

          _items[idx] = updated;
          _items.sort((a, b) => (_rankById[a.id]! ).compareTo(_rankById[b.id]! ));
        }
        _selected = updated;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro a atualizar: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ------------------- DELETE -------------------
  Future<bool> _deleteProperty(PropertyItem current) async {
    try {
      await _controller.delete(current.id);
      setState(() {
        _items.removeWhere((e) => e.id == current.id);
        _rankById.remove(current.id);
        if (_selected?.id == current.id) {
          _selected = _items.isNotEmpty ? _items.first : null;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propriedade apagada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro a apagar: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  // ------------------- SELECT -------------------
  void _selectProperty(PropertyModel property) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    final found = _items.firstWhere(
          (t) => identical(t.model, property) || t.model.title == property.title,
      orElse: () => _items.isNotEmpty ? _items.first : PropertyItem('', property),
    );

    if (isMobile) {
      _openDetailsBottomSheet(found);
    } else {
      setState(() => _selected = found);
    }
  }

  void _openDetailsBottomSheet(PropertyItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final h = MediaQuery.of(ctx).size.height;
        return SafeArea(
          child: Container(
            height: h * 0.92,
            decoration: BoxDecoration(
              color: Theme.of(ctx).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                  child: Row(
                    children: [
                      Text(
                        'Detalhes',
                        style: Theme.of(ctx)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PropertyDetailsPanel(
                      key: ValueKey(item.id),
                      name: item.model.title,
                      location: item.model.address,
                      bookings: item.model.bookings,
                      estimatedProfit: item.model.estimatedProfit,
                      type: item.model.type,
                      onUpdate: ({
                        required name,
                        required location,
                        required bookings,
                        required estimatedProfit,
                        required type,
                      }) async {
                        await _updateProperty(
                          current: item,
                          name: name,
                          location: location,
                          bookings: bookings,
                          estimatedProfit: estimatedProfit,
                          type: type,
                        );
                      },
                      onDelete: () async {
                        final ok = await _deleteProperty(item);
                        if (mounted){
                          if (ok && Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        }

                        return ok;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    final itemsOrdered = [..._items]..sort(
          (a, b) => (_rankById[a.id] ?? 0).compareTo(_rankById[b.id] ?? 0),
    );
    final properties = itemsOrdered.map((e) => e.model).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LayoutBuilder(
              builder: (context, c) {
                final isMobile = c.maxWidth < 900;
                return Row(
                  mainAxisAlignment:
                  isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: isMobile ? Alignment.centerLeft : Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.apartment,
                                size: 32, color: Colors.deepPurple.shade400),
                            const SizedBox(width: 8),
                            Text(
                              'Gestão de Propriedades',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Divider(color: Colors.blueAccent, thickness: 1.5),
          const SizedBox(height: 16),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : isMobile
                ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: AddPropertyButton(onPressed: _onAddPropertyPressed),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PropertiesGrid(
                    onSelect: _selectProperty,
                    selectedProperty: _selected?.model,
                    properties: properties,
                  ),
                ),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: AddPropertyButton(
                            onPressed: _onAddPropertyPressed,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: PropertiesGrid(
                          onSelect: _selectProperty,
                          selectedProperty: _selected?.model,
                          properties: properties,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Flexible(
                  flex: 4,
                  child: _selected == null
                      ? const Center(
                    child: Text(
                      'Seleciona uma propriedade para ver os detalhes',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                      : LayoutBuilder(
                    builder: (context, constraints) {
                      final m = _selected!.model;
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: PropertyDetailsPanel(
                          key: ValueKey(_selected!.id),
                          name: m.title,
                          location: m.address,
                          bookings: m.bookings,
                          estimatedProfit: m.estimatedProfit,
                          type: m.type,
                          onUpdate: ({
                            required name,
                            required location,
                            required bookings,
                            required estimatedProfit,
                            required type,
                          }) async {
                            await _updateProperty(
                              current: _selected!,
                              name: name,
                              location: location,
                              bookings: bookings,
                              estimatedProfit: estimatedProfit,
                              type: type,
                            );
                          },
                          onDelete: () => _deleteProperty(_selected!),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
