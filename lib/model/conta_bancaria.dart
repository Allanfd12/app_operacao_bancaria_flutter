class ContaBancaria{
  String? nome;
  String? documento;
  String? dataNascimento;
  String? numeroConta;
  String? senha;
  String? senhaConfirmacao;
  double saldo =0;

  ContaBancaria({this.nome, this.documento, this.dataNascimento, this.numeroConta, this.senha});

  Map toJson() =>{
    'nome' : nome,
    'documento': documento,
    'dataNascimento':dataNascimento,
    'numeroConta':numeroConta,
    'senha':senha,
    'saldo':saldo
  };
}