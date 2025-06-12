import 'package:flutter/material.dart';

enum ItemStatus {
  registrado, // Quando o item acabou de ser registrado
  emAnalise, // Quando a polícia está analisando o caso
  encontrado, // Quando o item foi encontrado
  recuperado, // Quando o item foi devolvido ao dono
  arquivado // Quando o caso foi arquivado
}

class StolenItem {
  final String id;
  final String userId;
  final String titulo;
  final String descricao;
  final String tipo;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final List<String> fotos;
  final DateTime dataRoubo;
  final String localRoubo;
  final String boletimOcorrencia;
  ItemStatus status;
  String? observacaoPolicial;
  DateTime dataCriacao;
  DateTime ultimaAtualizacao;

  StolenItem({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    required this.fotos,
    required this.dataRoubo,
    required this.localRoubo,
    required this.boletimOcorrencia,
    this.status = ItemStatus.registrado,
    this.observacaoPolicial,
    DateTime? dataCriacao,
    DateTime? ultimaAtualizacao,
  })  : this.dataCriacao = dataCriacao ?? DateTime.now(),
        this.ultimaAtualizacao = ultimaAtualizacao ?? DateTime.now();

  // Método para atualizar o status
  void atualizarStatus(ItemStatus novoStatus, {String? observacao}) {
    status = novoStatus;
    if (observacao != null) {
      observacaoPolicial = observacao;
    }
    ultimaAtualizacao = DateTime.now();
  }

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'titulo': titulo,
      'descricao': descricao,
      'tipo': tipo,
      'marca': marca,
      'modelo': modelo,
      'numeroSerie': numeroSerie,
      'fotos': fotos,
      'dataRoubo': dataRoubo.toIso8601String(),
      'localRoubo': localRoubo,
      'boletimOcorrencia': boletimOcorrencia,
      'status': status.toString(),
      'observacaoPolicial': observacaoPolicial,
      'dataCriacao': dataCriacao.toIso8601String(),
      'ultimaAtualizacao': ultimaAtualizacao.toIso8601String(),
    };
  }

  // Criar objeto a partir de JSON
  factory StolenItem.fromJson(Map<String, dynamic> json) {
    return StolenItem(
      id: json['id'],
      userId: json['userId'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      tipo: json['tipo'],
      marca: json['marca'],
      modelo: json['modelo'],
      numeroSerie: json['numeroSerie'],
      fotos: List<String>.from(json['fotos']),
      dataRoubo: DateTime.parse(json['dataRoubo']),
      localRoubo: json['localRoubo'],
      boletimOcorrencia: json['boletimOcorrencia'],
      status: ItemStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      observacaoPolicial: json['observacaoPolicial'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
      ultimaAtualizacao: DateTime.parse(json['ultimaAtualizacao']),
    );
  }
}
