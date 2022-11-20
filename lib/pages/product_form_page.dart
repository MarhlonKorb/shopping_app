import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

/// Classe responsável pelo formulário de cadastro de produtos
class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlCOntroller = TextEditingController();
  // GlobalKey retorna o estado atual do formulário
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  /// Libera os recursos de memória assim que o usuário sai da tela
  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
  }

  /// Método que junto com _imageUrlFocus.addListener(updateImage) no initState e dispose carrega a imagem
  /// no componente FittedBox a partir da sua URL
  void updateImage() {
    setState(() {});
  }

  void _onSubmitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    final newProduct = Product(
      // Salva o estado atual de cada campo do formulário
      id: Random().nextDouble().toString(),
      name: (_formData as Map<String, dynamic>)['name'].toString(),
      description:
          (_formData as Map<String, dynamic>)[' description'].toString(),
      price: (_formData as Map<String, dynamic>)['price'] as double,
      imageUrl: (_formData as Map<String, dynamic>)['imageUrl'].toString(),
    );
  }

  /// Valida a url e se a extensão é no formato png,jpg ou jpeg
  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de produto'),
        actions: [
          IconButton(
            onPressed: () => _onSubmitForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                // Segue para o próximo elemento/input
                textInputAction: TextInputAction.next,
                // Direciona o foco para o componente passado por parâmetro para o método
                // requestFocus()
                onFieldSubmitted: ((_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                }),
                onSaved: (name) =>
                    (_formData as Map<String, dynamic>)['name'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';
                  if (name.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  if (name.length < 3) {
                    return 'Nome deve conter ao menos 3 letras';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Preço'),
                // Segue para o próximo elemento/input
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) => (_formData
                    as Map<String, dynamic>)['price'] = double.parse(price!),
                    validator: (_price) {
                      final priceString = _price ?? '-1';
                      final price = double.tryParse(priceString) ?? -1;

                      if (price <= 0) {
                        return 'Informe um preço válido';
                      }
                      return null;
                    },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                onSaved: (description) => (_formData
                    as Map<String, dynamic>)['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';
                  if (description.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  if (description.length < 10) {
                    return 'Nome deve conter ao menos 10 letras';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Url da imagem'),
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocus,
                        keyboardType: TextInputType.url,
                        controller: _imageUrlCOntroller,
                        onFieldSubmitted: (_) => _onSubmitForm(),
                        onSaved: (urlImage) =>
                            (_formData as Map<String, dynamic>)['urlImage'] =
                                urlImage ?? '', 
                                validator: (_imageUrl) {
                                  final imageUrl = _imageUrl ?? '';
                                  if (!isValidImageUrl(imageUrl)) {
                                    return 'Informe uma Url válida';
                                  }
                                  return null;
                                },),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlCOntroller.text.isEmpty
                        ? const Text('Informe a URL:')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(_imageUrlCOntroller.text),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
