import 'package:flutter/material.dart';

class CategoryStyle {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static Color getColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color.fromARGB(255, 219, 201, 147);
      case 'school':
        return const Color(0xFFFF7A45);
      case 'transpo':
        return const Color(0xFF4D78E6);
      case 'groceries':
        return const Color(0xFF8AD99A);
      case 'bill':
        return const Color.fromARGB(255, 117, 197, 213);
      case 'custom':
        return const Color.fromARGB(255, 187, 107, 227);
      default:
        return const Color(0xFFBFC7D5);
    }
  }

  static IconData getIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'school':
        return Icons.school;
      case 'transpo':
        return Icons.directions_car;
      case 'groceries':
        return Icons.local_grocery_store;
      case 'bill':
        return Icons.receipt;
      case 'custom':
        return Icons.shopping_cart;
      default:
        return Icons.shopping_cart;
    }
  }
}
