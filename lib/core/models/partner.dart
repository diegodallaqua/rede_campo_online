/// Instituição parceira da Rede Campo.
class Partner {
  /// Nome curto ou sigla (ex.: "UTFPR").
  final String name;

  /// Nome por extenso da instituição.
  final String fullName;

  final String logoPath;

  /// Site oficial, aberto em uma nova aba ao tocar no card.
  final String url;

  /// Ampliação do logo para compensar arquivos com muita margem em branco,
  /// mantendo o peso visual parecido entre as marcas.
  final double logoScale;

  const Partner({
    required this.name,
    required this.fullName,
    required this.logoPath,
    required this.url,
    this.logoScale = 1.0,
  });
}

/// Parceiros institucionais exibidos na página inicial.
const List<Partner> institutionalPartners = [
  Partner(
    name: 'UTFPR',
    fullName: 'Universidade Tecnológica Federal do Paraná',
    logoPath: 'assets/images/utfpr.png',
    url: 'https://www.utfpr.edu.br/',
  ),
  Partner(
    name: 'SENAR Paraná',
    fullName: 'Serviço Nacional de Aprendizagem Rural do Paraná',
    logoPath: 'assets/images/senar.png',
    url: 'https://www.sistemafaep.org.br/',
    logoScale: 1.6,
  ),
  Partner(
    name: 'IDR-Paraná',
    fullName: 'Instituto de Desenvolvimento Rural do Paraná',
    logoPath: 'assets/images/idr.png',
    url: 'https://www.idrparana.pr.gov.br/',
  ),
];
