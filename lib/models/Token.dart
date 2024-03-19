// ignore_for_file: file_names

class Token {
  final String email;
  final String token;

  Token({required this.email, required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    //var obj = json['nombrelista']
    return Token(
      email: json["email"],
      token: json["token"],
      //listas: new List<String>.from(obj);
    );
  }
}