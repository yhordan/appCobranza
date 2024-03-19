// ignore_for_file: non_constant_identifier_names, camel_case_types

class Dto_estadistica {

   final String abreviatura;
   final int total_cartera;
   final int total_visitados;
  //List<String> listas;

  Dto_estadistica({ 
    required this.abreviatura,
    required this.total_cartera,
    required this.total_visitados,
  });

  factory Dto_estadistica.fromJson(Map<String, dynamic> json){
    //var obj = json['nombrelista']
      return Dto_estadistica(
        abreviatura:json["abreviatura"],
        total_cartera:json["total_cartera"],
        total_visitados:json["total_visitados"],
      );
  }
}
