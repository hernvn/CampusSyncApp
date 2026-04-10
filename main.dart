import 'package:flutter/material.dart';

void main() {
  runApp(const CampusSyncApp());
}

class CampusSyncApp extends StatelessWidget {
  const CampusSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusSync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PantallaLogin(),
    );
  }
}


// 1. PANTALLA LOGIN 

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String _mensajeError = '';

  void _validarIngreso() {
    setState(() {
      if (_userController.text.isEmpty || _passController.text.isEmpty) {
        _mensajeError = 'Debes ingresar tu correo y contraseña.';
      } else {
        _mensajeError = '';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PantallaInicio()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusSync - Ingreso'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Correo Institucional', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            Text(_mensajeError, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: _validarIngreso,
              child: const Text('Entrar a la Universidad'),
            ),
          ],
        ),
      ),
    );
  }
}


// 2. PANTALLA INICIO 

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CampusSync'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Bienvenido Estudiante', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.library_books, color: Colors.orange),
                  title: const Text('Explorar Apuntes'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaApuntes())),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_search, color: Colors.green),
                  title: const Text('Buscar Tutores'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaTutores())),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.blue),
                  title: const Text('Subir mi Material'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaSubirApuntes())),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.account_circle, color: Colors.purple),
                  title: const Text('Mi Perfil'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PantallaPerfil())),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red))
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}


// 3. PANTALLA APUNTES 

class PantallaApuntes extends StatefulWidget {
  const PantallaApuntes({super.key});

  @override
  State<PantallaApuntes> createState() => _PantallaApuntesState();
}

class _PantallaApuntesState extends State<PantallaApuntes> {
  // Lista de datos simulando nuestra base de materias
  final List<Map<String, dynamic>> _todasLasMaterias = [
    {'nombre': 'Base de Datos 2', 'icono': Icons.storage, 'color': Colors.blue, 'facultad': 'Ingeniería'},
    {'nombre': 'Programación en Python', 'icono': Icons.code, 'color': Colors.green, 'facultad': 'Ingeniería'},
    {'nombre': 'Termodinámica', 'icono': Icons.local_fire_department, 'color': Colors.orange, 'facultad': 'Ciencias'},
    {'nombre': 'Cálculo Avanzado', 'icono': Icons.functions, 'color': Colors.red, 'facultad': 'matemáticas'},
    {'nombre': 'Anatomía Básica', 'icono': Icons.favorite, 'color': Colors.pink, 'facultad': 'Ciencias de la salud'},
  ];

  List<Map<String, dynamic>> _materiasMostradas = [];
  String _facultadSeleccionada = 'Todas';
  String _textoBusqueda = '';

  @override
  void initState() {
    super.initState();
    _materiasMostradas = List.from(_todasLasMaterias);
  }

  // Lógica de filtrado
  void _aplicarFiltros() {
    setState(() {
      _materiasMostradas = _todasLasMaterias.where((materia) {
        final coincideTexto = materia['nombre'].toLowerCase().contains(_textoBusqueda.toLowerCase());
        final coincideFacultad = _facultadSeleccionada == 'Todas' || materia['facultad'] == _facultadSeleccionada;
        return coincideTexto && coincideFacultad;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asignaturas')),
      body: Column(
        children: [
          // Barra de Búsqueda simple
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (valor) {
                _textoBusqueda = valor;
                _aplicarFiltros();
              },
              decoration: const InputDecoration(
                hintText: 'Buscar asignatura...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          // Botones de filtro de facultad
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                _crearFiltroChip('Todas'),
                const SizedBox(width: 8),
                _crearFiltroChip('Ingeniería'),
                const SizedBox(width: 8),
                _crearFiltroChip('Ciencias'),
                const SizedBox(width: 8),
                _crearFiltroChip('Salud'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Lista de resultados mostrados con un ListView normal
          Expanded(
            child: _materiasMostradas.isEmpty
                ? const Center(child: Text('No se encontraron asignaturas.'))
                : ListView(
                    padding: const EdgeInsets.all(10),
                    children: _materiasMostradas.map((materia) {
                      return _filaMateria(context, materia['nombre'], materia['icono'], materia['color'], materia['facultad']);
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _crearFiltroChip(String nombreFacultad) {
    final bool seleccionado = _facultadSeleccionada == nombreFacultad;
    return FilterChip(
      label: Text(nombreFacultad, style: TextStyle(color: seleccionado ? Colors.white : Colors.black87)),
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.blue,
      selected: seleccionado,
      onSelected: (bool valor) {
        _facultadSeleccionada = nombreFacultad;
        _aplicarFiltros();
      },
    );
  }

  Widget _filaMateria(BuildContext contexto, String nombre, IconData icono, Color color, String facultad) {
    return Card(
      child: ListTile(
        leading: Icon(icono, color: color),
        title: Text(nombre),
        subtitle: Text(facultad),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          Navigator.push(contexto, MaterialPageRoute(builder: (context) => PantallaRepositorioReal(nombreMateria: nombre)));
        },
      ),
    );
  }
}


// 4. PANTALLA REPOSITORIO

class PantallaRepositorioReal extends StatelessWidget {
  final String nombreMateria;
  const PantallaRepositorioReal({super.key, required this.nombreMateria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apuntes de $nombreMateria'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _elementoArchivo('Resumen y Esquemas', 'Estudiante 01', '4.8'),
          _elementoArchivo('Proyectos Resueltos', 'Juan Desarrollador', '4.5'),
          _elementoArchivo('Guía de Preparación Final', 'Maria Ingeniera', '5.0'),
        ],
      ),
    );
  }

  Widget _elementoArchivo(String titulo, String autor, String estrellas) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(titulo),
        subtitle: Text('Por: $autor • ⭐ $estrellas'),
        trailing: const Icon(Icons.download, color: Colors.blue),
      ),
    );
  }
}


// 5. PANTALLA TUTORES 

class PantallaTutores extends StatelessWidget {
  const PantallaTutores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutores Disponibles')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _tarjetaTutor(context, 'Prof. Cristofher Rojas', 'Desarrollo de Apps', Colors.blue, '\$10.000'),
          _tarjetaTutor(context, 'Ayudante Hernán Escobar', 'Cálculo y Álgebra', Colors.red, '\$5.000'),
          _tarjetaTutor(context, 'Ing. Rodolfo Durán', 'Base de Datos', Colors.green, '\$8.000'),
        ],
      ),
    );
  }

  Widget _tarjetaTutor(BuildContext context, String nombre, String especialidad, Color color, String precio) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: const Icon(Icons.person, color: Colors.white)),
        title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$especialidad \nTarifa: $precio/hr'),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: () {
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Abriendo chat con $nombre...')),
            );
          },
          child: const Text('Contactar'),
        ),
      ),
    );
  }
}


// 6. PANTALLA SUBIR APUNTES 

class PantallaSubirApuntes extends StatelessWidget {
  const PantallaSubirApuntes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compartir Material')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.cloud_upload, size: 80, color: Colors.blue),
            const TextField(decoration: InputDecoration(labelText: 'Nombre del Archivo')),
            const TextField(decoration: InputDecoration(labelText: 'Materia')),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: () {}, child: const Text('Seleccionar PDF')),
          ],
        ),
      ),
    );
  }
}


// 7. PANTALLA PERFIL 

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('Estudiante Universitario', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const Center(child: Text('Ingeniería Civil Informática', style: TextStyle(fontSize: 16, color: Colors.grey))),
          const SizedBox(height: 30),
          

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _columnaEstadistica('Apuntes', '3'),
              _columnaEstadistica('Descargas', '128'),
              _columnaEstadistica('Puntos', '490'),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Editar Perfil')),
          const Divider(height: 40),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Configuración'), onTap: () {}),
          ListTile(leading: const Icon(Icons.help), title: const Text('Ayuda y Soporte'), onTap: () {}),
        ],
      ),
    );
  }

  Widget _columnaEstadistica(String titulo, String valor) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 4),
        Text(titulo, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}