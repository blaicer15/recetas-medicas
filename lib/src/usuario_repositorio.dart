import 'package:recetas_medicas/src/model/models.dart';
import 'package:uuid/uuid.dart';

class UsuarioRepositorio {
  Usuario? _user;

  Future<Usuario?> getUser() async {
    if (_user != null) return _user;
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => _user = Usuario(
        id: const Uuid().v4(),
        nombre: 'Juan',
        apePaterno: 'Pérez',
        apeMaterno: 'García',
        edad: '30',
        peso: '70',
        estatura: '1.75',
      ),
    );
  }
}
