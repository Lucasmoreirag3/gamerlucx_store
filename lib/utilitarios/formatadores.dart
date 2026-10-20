import 'package:intl/intl.dart';

/// Critério 6 (Desejável): Diferenciando características da linguagem Dart.
/// Aqui utilizamos Extension Methods e Mixins, recursos expressivos e específicos do Dart
/// que não existem da mesma forma em linguagens como Java tradicional ou C padrão.

final NumberFormat _formatadorReal = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: 'R\$',
  decimalDigits: 2,
);

/// Extensão no tipo primitivo double do Dart para facilitar formatação monetária.
extension FormatadorPreco on double {
  String paraReal() {
    return _formatadorReal.format(this);
  }

  /// Calcula e formata valor parcelado em até 12x sem juros
  String emAte12x() {
    final valorParcela = this / 12;
    return '12x de ${_formatadorReal.format(valorParcela)} sem juros';
  }
}

/// Extensão para manipulação elegante de Strings em Dart
extension FormatadorTexto on String {
  String capitalizarPrimeira() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String limitarComReticencias(int maximoCaracteres) {
    if (length <= maximoCaracteres) return this;
    return '${substring(0, maximoCaracteres)}...';
  }
}

/// Mixin para validação reutilizável de formulários em Dart
mixin ValidadorFormularioMixin {
  String? validarTextoObrigatorio(String? valor, String nomeCampo) {
    if (valor == null || valor.trim().isEmpty) {
      return '$nomeCampo é obrigatório';
    }
    return null;
  }

  String? validarNumeroPositivo(String? valor, String nomeCampo) {
    if (valor == null || valor.trim().isEmpty) {
      return '$nomeCampo é obrigatório';
    }
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null) {
      return 'Digite um número válido';
    }
    if (numero <= 0) {
      return '$nomeCampo deve ser maior que zero';
    }
    return null;
  }

  String? validarCep(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o CEP';
    }
    final cepLimpo = valor.replaceAll(RegExp(r'\D'), '');
    if (cepLimpo.length != 8) {
      return 'CEP deve conter 8 dígitos numéricos';
    }
    return null;
  }
}
