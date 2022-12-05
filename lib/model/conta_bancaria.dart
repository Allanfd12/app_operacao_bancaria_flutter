class ContaBancaria{
  String nome;
  String documento;
  String dataNascimento;
  String conta;
  String senha;

  ContaBancaria(this.nome, this.documento, this.dataNascimento, this.conta, this.senha);

  Map toJson() =>{
    'nome' : nome,
    'documento': documento,
    'dataNascimento':dataNascimento,
    'conta':conta,
    'senha':senha
  };
}