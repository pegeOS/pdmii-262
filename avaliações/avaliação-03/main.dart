import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> abrirBancoDeDados() async {
  try {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final caminhoBanco = p.join(Directory.current.path, 'alunos.db');
    final bancoJaExistia = await File(caminhoBanco).exists();

    final db = await databaseFactory.openDatabase(
      caminhoBanco,
      options: OpenDatabaseOptions(version: 1),
    );

    if (!bancoJaExistia) {
      print('Banco de dados alunos.db nao existia e foi criado em: $caminhoBanco');
    } else {
      print('Banco de dados alunos.db ja existia. Conexao aberta normalmente.');
    }

    try {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS tb_alunos (
          id     INTEGER PRIMARY KEY AUTOINCREMENT,
          nome   TEXT NOT NULL,
          idade  INTEGER NOT NULL,
          curso  TEXT NOT NULL
        )
      ''');
      print('Tabela tb_alunos verificada/criada com sucesso.');
    } catch (e) {
      print('Erro ao criar a tabela tb_alunos: $e');
      rethrow;
    }

    return db;
  } catch (e) {
    print('Erro ao abrir/criar o banco de dados: $e');
    rethrow;
  }
}

Future<void> inserirAlunos(Database db) async {
  try {
    final resultadoContagem = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM tb_alunos',
    );
    final totalAtual = resultadoContagem.isNotEmpty
        ? resultadoContagem.first['total'] as int?
        : null;

    if (totalAtual != null && totalAtual > 0) {
      print('A tabela ja possui $totalAtual aluno(s). Insercao ignorada.');
      return;
    }

    final alunos = <Map<String, Object?>>[
      {'nome': 'Ana Souza', 'idade': 20, 'curso': 'Engenharia de Software'},
      {'nome': 'Bruno Lima', 'idade': 22, 'curso': 'Ciencia da Computacao'},
      {'nome': 'Carla Melo', 'idade': 19, 'curso': 'Sistemas de Informacao'},
    ];

    for (final aluno in alunos) {
      await db.insert('tb_alunos', aluno);
    }

    print('3 alunos inseridos com sucesso.');
  } catch (e) {
    print('Erro ao inserir alunos: $e');
  }
}

Future<void> listarAlunos(Database db) async {
  try {
    final resultado = await db.query('tb_alunos');

    if (resultado.isEmpty) {
      print('Nenhum aluno encontrado na tabela tb_alunos.');
      return;
    }

    print('\n--- Lista de Alunos ---');
    for (final linha in resultado) {
      print(
        'ID: ${linha['id']} | Nome: ${linha['nome']} | '
        'Idade: ${linha['idade']} | Curso: ${linha['curso']}',
      );
    }
    print('------------------------\n');
  } catch (e) {
    print('Erro ao listar alunos: $e');
  }
}

Future<void> main() async {
  Database? db;
  try {
    db = await abrirBancoDeDados();
    await inserirAlunos(db);
    await listarAlunos(db);
  } catch (e) {
    print('Erro geral na execucao do programa: $e');
  } finally {
    if (db != null) {
      try {
        await db.close();
        print('Conexao com o banco de dados encerrada.');
      } catch (e) {
        print('Erro ao fechar o banco de dados: $e');
      }
    }
  }
}