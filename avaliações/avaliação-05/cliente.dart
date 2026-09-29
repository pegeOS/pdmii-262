import 'dart:convert';

import 'package:http/http.dart' as http;

import '../lib/aluno.dart';

const String servidorUrl = 'http://localhost:8080/alunos';

Future<void> main() async {
  try {
    final response = await http.get(Uri.parse(servidorUrl));

    if (response.statusCode != 200) {
      print('Erro ao acessar o servidor: HTTP ${response.statusCode}');
      return;
    }

    final List<dynamic> dadosJson = jsonDecode(response.body);
    final List<Aluno> alunos = dadosJson.map((json) => Aluno.fromJson(json)).toList();

    _imprimirCabecalho();

    for (final aluno in alunos) {
      final mensagem = _calcularMensagem(aluno);
      _imprimirAluno(aluno, mensagem);
    }
  } catch (e) {
    print('Não foi possível conectar ao servidor em $servidorUrl');
    print('Detalhe do erro: $e');
  }
}

/// Calcula a mensagem final do aluno, garantindo que apenas UMA seja impressa.
/// A reprovação por faltas tem prioridade sobre o resultado da média.
String _calcularMensagem(Aluno aluno) {
  String mensagem;

  if (aluno.media < 6.0) {
    mensagem = 'Reprovado';
  } else {
    mensagem = 'Aprovado';
  }

  if (aluno.faltas > 20) {
    mensagem = 'Reprovado por Faltas';
  }

  return mensagem;
}

void _imprimirCabecalho() {
  print(
    '${'ID'.padRight(4)}'
    '${'NOME'.padRight(18)}'
    '${'DISCIPLINA'.padRight(24)}'
    '${'MEDIA'.padRight(8)}'
    '${'FALTAS'.padRight(8)}'
    'MENSAGEM',
  );
  print('-' * 80);
}

void _imprimirAluno(Aluno aluno, String mensagem) {
  print(
    '${aluno.id.toString().padRight(4)}'
    '${aluno.nome.padRight(18)}'
    '${aluno.disciplina.padRight(24)}'
    '${aluno.media.toStringAsFixed(1).padRight(8)}'
    '${aluno.faltas.toString().padRight(8)}'
    '$mensagem',
  );
}