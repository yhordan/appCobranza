// ignore: camel_case_types
class app_tablas   {
  final String idtabla;
  final String descripcion;
  final String valor;
  final String valor2;
  final String tipo;
  final String estado;
   final String nombre;

  app_tablas({
    required this.idtabla,
    required this.descripcion,
    required this.valor,
    required this.valor2,
    required this.tipo,
    required this.estado,
    required this.nombre,
  });

  factory app_tablas.fromJson(Map<String, dynamic> json) {
    return app_tablas(
      idtabla: json["idtabla"],
      descripcion: json["descripcion"],
      valor: json["valor"],
      valor2: json["valor2"],
      tipo: json["tipo"],
      estado: json["estado"],
      nombre: json["nombre"],
    );
  }
}
