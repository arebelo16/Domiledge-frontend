import 'package:flutter/material.dart';
import '../../../core/models/property_model.dart';

class PropertiesGrid extends StatelessWidget {
  final void Function(PropertyModel) onSelect;
  final PropertyModel? selectedProperty;
  final List<PropertyModel> properties;

  const PropertiesGrid({
    super.key,
    required this.onSelect,
    required this.selectedProperty,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: properties.length,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0), // alinha com o botão
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final property = properties[index];
        final isSelected = selectedProperty?.title == property.title;

        return InkWell(
          onTap: () => onSelect(property),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple.shade200 : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.deepPurple.shade100, blurRadius: 10)]
                  : [],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.house, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Tooltip(
                    message: property.title,
                    waitDuration: const Duration(milliseconds: 500),
                    child: Text(
                      property.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
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
}
