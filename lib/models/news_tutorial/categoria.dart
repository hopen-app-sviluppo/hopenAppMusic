//categorie di news e tutorial di riferimento

class Categoria {
  final String id;
  final String name;

  Categoria({
    required this.id,
    required this.name,
  });

  static Categoria fromJSON(Map<String, dynamic> data) {
    final categoria = Categoria(
      id: data['id'],
      name: data['categoria'],
    );
    return categoria;
  }

  @override
  String toString() => "id_categoria: $id, nome_categoria: $name";
}
