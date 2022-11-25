import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

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
  final _imageUrlController = TextEditingController();
  // GlobalKey retorna o estado atual do formulário
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  /// Carrega dados em momentos específicos
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      // Se arg não for nulo, os dados estão vindo de uma tela de edição
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  /// Libera os recursos de memória assim que o usuário sai da tela
  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  /// Método que junto com _imageUrlFocus.addListener(updateImage) no initState e dispose carrega a imagem
  /// no componente FittedBox a partir da sua URL
  void updateImage() {
    setState(() {});
  }

  Future<void> _onSubmitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro.'),
          content: const Text('Ocorreu um erro ao salvar o produto.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } finally {
// Valida o estado do CircularProgressIndicator
      setState(() => _isLoading = false);
    }
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
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          TextFormField(
                            // Recupera o valor do dado carregado no método didChangeDependencies()
                            initialValue: _formData['name']?.toString(),
                            decoration:
                                const InputDecoration(labelText: 'Nome'),
                            // Segue para o próximo elemento/input
                            textInputAction: TextInputAction.next,
                            // Direciona o foco para o componente passado por parâmetro para o método
                            // requestFocus()
                            onFieldSubmitted: ((_) {
                              FocusScope.of(context).requestFocus(_priceFocus);
                            }),
                            onSaved: (name) => (_formData)['name'] = name ?? '',
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
                            initialValue: _formData['price']?.toString(),
                            decoration:
                                const InputDecoration(labelText: 'Preço'),
                            // Segue para o próximo elemento/input
                            textInputAction: TextInputAction.next,
                            focusNode: _priceFocus,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocus);
                            },
                            onSaved: (price) =>
                                (_formData)['price'] = double.parse(price!),
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
                            initialValue: _formData['description']?.toString(),
                            decoration:
                                const InputDecoration(labelText: 'Descrição'),
                            focusNode: _descriptionFocus,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            onSaved: (description) =>
                                (_formData)['description'] = description ?? '',
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
                                  decoration: const InputDecoration(
                                      labelText: 'Url da imagem'),
                                  textInputAction: TextInputAction.done,
                                  focusNode: _imageUrlFocus,
                                  keyboardType: TextInputType.url,
                                  controller: _imageUrlController,
                                  onFieldSubmitted: (_) => _onSubmitForm(),
                                  onSaved: (urlImage) =>
                                      (_formData)['urlImage'] = urlImage ?? '',
                                  validator: (_imageUrl) {
                                    final imageUrl = _imageUrl ?? '';
                                    if (!isValidImageUrl(imageUrl)) {
                                      return 'Informe uma Url válida';
                                    }
                                  },
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                margin:
                                    const EdgeInsets.only(top: 10, left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: _imageUrlController.text.isEmpty
                                    ? const Text('Informe a URL:')
                                    : Image.network(_imageUrlController.text),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
  }
}
