import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Cálculo de IMC',
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /*
   * Para pegar as informações do TextField temos que criar um objeto do tipo
   * TextEditingController que instancia um novo TextEditingController. Essa 
   * classe que é um controller tem varios métodos para editar as informações
   * do TextField escolhido. Para que possamos utilizar esse objeto criado no 
   * TextField temos que colocar o parametro "controller" dentro do TextField
   * e em seguida o nome do objeto que criamos que instancia de TextEditingController
   */
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  /**
   * Para podermos validar os TextFields que criamos temos que seguir alguns passos:
   * 1º - criar uma variavel do tipo GlobalKey<FormState> que instancia a classe
   * GlobalKey<FormState>. Essa _formKey vai ser uma chave que vai guardar as
   * informações enviadas dos TextFields para que possamos fazer a validação. Já
   * a classe FormState vai ficar verificando se houve alteração nos TextFields 
   * do formulário.
   * 
   * 2º - Em seguida o segundo passo é adicionarmos todos os elementos (widgets)
   * da tela que tem alguma relação com os TextFields dentro do child de um componente 
   * chamdo Form(). No nosso caso temos que adicionar todos os widgets que estão 
   * dentre de home.
   * 
   * 3º - O widget Form() recebe um parametro chamdo "key" e é nesse parametro 
   * que vamos passar a variavel _formKey que criamos.
   * 
   * 4º - Para que possamos usar a validação de formulario temos que mudar os 
   * TextFields para outro tipo de widget chamdo TextFormField.
   * 
   * 5º - Como mudamos para TextFormField, esse recebe como parametro o "validator"
   * que tem uma função anomina com um parametro chamdo "value". Dentro do escopo
   * da função podemos passar uma validação para verificar o que quisermos do "value"
   * que chegou. Essa nossa validação se for verdadeira vai retornar algo que vai ser
   * apresentado na tela como um erro referente aquele TextFormField
   * 
   * 6º - O último passo é fazer uma verificação no onpressed do botao que envia
   * as informações do formulario. Lá vamos fazer uma verificação usando o if na 
   * variável global que criamos dessa forma _formKey.currentState.validate(),
   * essa verificação vai acessar a variavel global e verificar se o estado atual
   * dela é validada, ou seja, se todos os campos estão devidamente preenchidos
   * de acordo com as regras de validações que criamos dentro de cada TextFormField 
   * no parâmetro "validator".
   * 
   * 
   */
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _info = '';

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _info = ''; //seta vazio na variável _info quando o botao reset é clicado
      _formKey = GlobalKey<
          FormState>(); //seta uma nova instancia de GlobalKey<FormState>()
      //na variavel _formKey para que os erros de validação dos TextFormFields desapareçam
    });
  }

  void _calculator() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      if (imc < 18.5) {
        _info =
            'Você está abaixo do peso ideal. Seu imc é ${imc.toStringAsPrecision(3)}';
      } else if (imc >= 18.5 && imc <= 24.9) {
        _info =
            'Você está dentro do seu peso ideal. Seu imc é ${imc.toStringAsPrecision(3)}';
      } else if (imc >= 25.0 && imc <= 29.9) {
        _info =
            'Você está com sobrepeso. Obesidade de grau I. Seu imc é ${imc.toStringAsPrecision(3)}';
      } else if (imc >= 30.0 && imc <= 39.9) {
        _info =
            'Você está com obesidade de grau II. Seu imc é ${imc.toStringAsPrecision(3)}';
      } else {
        _info =
            'Você está com obesidade grave de grau III. Seu imc é ${imc.toStringAsPrecision(3)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /* o widget Scaffold é muito bom se você quer construir algo de forma rápida
     * ele tem vários parâmetros em seu construtor que torna muito fácil a
     * criação do aplicativo de forma rápida. Por exemplo, se você quer criar
     * uma appbar o scaffold já tem um parametro que recebe um widget do tipo
     * appbar e esse widget appbar recebe outros parametros para sua construção
     * como o title, centerTitle, backgroundColor, actions.
     */
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculadora de IMC',
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      /** 
       * O widget SingleCildScrollView é usado para fazer com que a view possa 
       * ter uma rolagem vertical para evitar que widgets se sobreponham uns
       * sobre os outros e de um erro de layout
       */
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              /** 
              * O CrossAxisAlignment é usado para alinhamento no eixo cruzado.
              * No caso do stretch o item ocupa toda a largura da tela
              */
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'images/person.png',
                  height: 200.0,
                  color: Colors.black54,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Digite seu peso atual(Kg):',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                    controller:
                        weightController, //Aqui dizemos qual controller vai ficar responsavel por esse TextField
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu peso";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Digite a sua altura atual(cm):',
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                    controller:
                        heightController, //Aqui dizemos qual controller vai ficar responsavel por esse TextField
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira sua altura";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                  child: Container(
                    height: 45.0,
                    child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _calculator();
                          }
                        },
                        child: Text(
                          'Calcular',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        color: Colors.deepOrange),
                  ),
                ),
                Text(
                  '$_info',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )),
    );
  }
}
