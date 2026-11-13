import '../../../core/global/constants/api_constants.dart';
import '../../publications/repositories/publication_type_repository.dart';
import '../models/academic_work.dart';

class AcademicWorkRepository extends PublicationTypeRepository<AcademicWork> {
  const AcademicWorkRepository();

  @override
  String get path => academicWorksURL;

  @override
  String get singular => 'Trabalho Acadêmico';

  @override
  String get plural => 'Trabalhos Acadêmicos';

  @override
  AcademicWork fromMap(Map<String, dynamic> map) => AcademicWork.fromMap(map);

  @override
  Map<String, dynamic> toMap(AcademicWork item) => item.toMap();

  @override
  int? publicationIdOf(AcademicWork item) => item.publication?.id;
}
