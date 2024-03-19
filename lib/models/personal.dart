class Personal {
  final String login;
  final String persona;
  final String idpersona;
  final String password;
  final String correo;
  final String? habilitado;
  final String? iduser;
  final String? cargo;
  final String? estado;
  final String? idcargo;
   final String? idagencia;
    final String? idarea;

  Personal({
    required this.login,
    required this.persona,
    required this.password,
    required this.correo,
    required this.idpersona,
    this.habilitado,
    this.cargo,
    this.estado,
    this.iduser,
    this.idcargo,
    this.idagencia,
    this.idarea,
  });

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal( 
      login: json["login"],
      persona: json["persona"],
      idpersona: json["idpersona"],
      password: json["password"],
      correo: json["correo"],
      habilitado: json["habilitado"],
      estado: json["estado"],
      cargo: json["cargo"],
      iduser: json["iduser"],
      idcargo: json["idcargo"],
      idagencia: json["idagencia"],
      idarea: json["idarea"],
    );
  }
}
