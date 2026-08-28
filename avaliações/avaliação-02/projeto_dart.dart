// 14-agregacao.dart  
// Agregação e Composição

import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome){
    _nome = nome;
  }

  Map<String, dynamic> toJson() => {
    'nome': _nome,
  };  

}

class Funcionario {

  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    _nome = nome;
    _dependentes = dependentes;
  }

  Map<String, dynamic> toJson() => {
    'nome': _nome,
    'dependentes': _dependentes,
  };
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() => {
    'nomeProjeto': _nomeProjeto,
    'funcionarios': _funcionarios,
  };
}

void main() {
  //Atividade:
  // 1. Criar varios objetos Dependentes
  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios
  // 4. Criar uma lista de Funcionarios
  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  // 6. Printar no formato JSON o objeto Equipe Projeto.

  Dependente dependente1 = Dependente("pedro");
  Dependente dependente2 = Dependente("artur");
  Dependente dependente3 = Dependente("savio");

  Funcionario funcionario1 = Funcionario("wilton", [dependente1]);
  Funcionario funcionario2 = Funcionario("flavio", [dependente2]);
  Funcionario funcionario3 = Funcionario("roger", [dependente3]);

  List<Funcionario> lista = [funcionario1, funcionario2, funcionario3];

  EquipeProjeto equipe = EquipeProjeto("Projeto Dart", lista);

  String json = jsonEncode(equipe);
  print(json);
}
