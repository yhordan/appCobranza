
// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_initializing_formals

class catalogo {
  int? id_catalogo;
  String? tabla;
  String? opcion;
  String? descripcion;
  String? estado;
  catalogo(id_catalogo, tabla, opcion, descripcion, estado){ 
    this.id_catalogo = id_catalogo;
    this.tabla = tabla;
    this.opcion = opcion;
    this.descripcion = descripcion;
    this.estado = estado;
  }
}