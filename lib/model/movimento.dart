class Movimento{
  String? origem;
  String? destino;
  double? valor;
  String? valorString;

  Movimento({this.origem, this.destino, this.valor,this.valorString});

  Map toJson() =>
      {
        'origem' :origem,
        'destino' : destino,
        'valor' : valor
      };

}