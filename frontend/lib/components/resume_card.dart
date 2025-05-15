import 'package:flutter/material.dart';

// Componente reutilizable CustomCard
class ResumeCard extends StatelessWidget {
  final int success;
  final DateTime created;
  final String description;

  const ResumeCard({
    Key? key,
    required this.success,
    required this.created,
    required this.description,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    // Obtener el día, mes y año
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();

    // Concatenar en formato dd/MM/yyyy
    return "$day/$month/$year";
  }

  Widget _buildContext(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_formatDate(created)}    Aciertos ${success}%',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: const [
              Chip(
                label: Text("Futbol"),
                backgroundColor: Color(0xFFE0C84B),
              ),
              Chip(
                label: Text("Álgebra"),
                backgroundColor: Color(0xFFE0C84B),
              ),
              Chip(
                label: Text("Trigonometría"),
                backgroundColor: Color(0xFFE0C84B),
              ),
              Chip(
                label: Text("Voley"),
                backgroundColor: Color(0xFFE0C84B),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6E1B),
              ),
              onPressed: () {},
              child: const Text('VER QUIZ'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }
}
