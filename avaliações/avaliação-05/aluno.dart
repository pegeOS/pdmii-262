
class Aluno {
  final int id;
  final String nome;
  final String disciplina;
  final double media;
  final int faltas;

  Aluno({
    required this.id,
    required this.nome,
    required this.disciplina,
    required this.media,
    required this.faltas,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'] as int,
      nome: json['nome'] as String,
      disciplina: json['disciplina'] as String,
      media: (json['media'] as num).toDouble(),
      faltas: json['faltas'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'disciplina': disciplina,
      'media': media,
      'faltas': faltas,
    };
  }
}