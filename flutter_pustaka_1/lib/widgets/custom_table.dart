import 'package:flutter/material.dart';

class CustomTable<T> extends StatelessWidget {
  final List<T> data;
  final List<String> columns;
  final List<String> Function(T item) rows;
  final void Function(T item) onEdit;
  final void Function(T item) onDelete;

  const CustomTable({
    Key? key,
    required this.data,
    required this.columns,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.brown[200]),
          border: TableBorder.all(
            color: Colors.brown.shade400,
            width: 1,
          ),
          columns: [
            ...columns.map(
              (column) => DataColumn(
                label: Text(
                  column,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                "Aksi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          rows: data.map((item) {
            final cells = rows(item);
            return DataRow(
              cells: [
                ...cells.map(
                  (cell) => DataCell(
                    Text(
                      cell,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onEdit(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete(item),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
