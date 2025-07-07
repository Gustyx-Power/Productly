import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: "All",
      decoration: const InputDecoration(
        labelText: "Kategori",
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: "All", child: Text("Semua")),
        DropdownMenuItem(value: "Clothes", child: Text("Clothes")),
        DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
      ],
      onChanged: (val) {},
    );
  }
}