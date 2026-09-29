import 'dart:convert';
import 'dart:io';

import '../lib/aluno.dart';

final List<Aluno> alunos = [
  Aluno(id: 1, nome: 'Ana Souza', disciplina: 'Banco de Dados', media: 8.5, faltas: 2),
  Aluno(id: 2, nome: 'Bruno Lima', disciplina: 'Programação Web', media: 5.2, faltas: 10),
  Aluno(id: 3, nome: 'Carla Mendes', disciplina: 'Estrutura de Dados', media: 7.0, faltas: 25),
  Aluno(id: 4, nome: 'Diego Alves', disciplina: 'Redes de Computadores', media: 9.1, faltas: 5),
  Aluno(id: 5, nome: 'Elisa Costa', disciplina: 'Engenharia de Software', media: 4.3, faltas: 30),
  Aluno(id: 6, nome: 'Fábio Rocha', disciplina: 'Sistemas Operacionais', media: 6.8, faltas: 8),
];

Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Servidor rodando em http://localhost:${server.port}');

  await for (HttpRequest request in server) {
    _handleRequest(request);
  }
}

void _handleRequest(HttpRequest request) {
  // habilita cors para facilitar testes a partir de clientes diversos
  request.response.headers.add('Access-Control-Allow-Origin', '*');
  request.response.headers.contentType = ContentType.json;

  if (request.method == 'GET' && request.uri.path == '/alunos') {
    final listaJson = alunos.map((a) => a.toJson()).toList();
    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(listaJson))
      ..close();
  } else {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write(jsonEncode({'erro': 'Rota não encontrada'}))
      ..close();
  }
}