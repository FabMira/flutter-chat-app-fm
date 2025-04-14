import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/presentation/models/models.dart';
import 'package:chat/services/services.dart';

class UsuariosPage extends ConsumerStatefulWidget {
  const UsuariosPage({super.key});

  @override
  UsuariosPageState createState() => UsuariosPageState();
}

class UsuariosPageState extends ConsumerState<UsuariosPage> {
  List<Usuario> users = [];
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  Future<void> _onRefresh() async {
    final users = await ref.refresh(usersListProvider.future);
    if (users.isNotEmpty) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersListProvider);
    final authService = ref.watch(authProvider.notifier);
    final socketService = ref.watch(socketServiceProvider.notifier);
    final usuario = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: usuario.when(
          data: (usuario) {
            return Text(usuario?.nombre ?? 'Sin nombre');
          },
          loading: () => const Text('Cargando...'),
          error: (error, stackTrace) => const Text('Error'),
        ),
        // Text(usuario?.nombre ?? 'Sin nombre'),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app_outlined),
          onPressed: () {
            socketService.disconnect();
            authService.deleteToken();
            if (context.mounted) context.pushReplacementNamed('login');
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child:
                (ref.watch(socketServiceProvider) == ServerStatus.online)
                    ? Icon(Icons.check_circle, color: Colors.blue[400])
                    : Icon(Icons.check_circle, color: Colors.red),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: usersAsync.when(
          data: (users) => _listViewUsuarios(users),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  ListView _listViewUsuarios(List<Usuario> users) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (_, index) => _usuarioListTile(users[index]),
      separatorBuilder: (_, index) => Divider(color: Colors.transparent),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        ref.read(usuarioParaProvider.notifier).setUsuario(usuario);
        if (context.mounted) {
          context.pushNamed('chat');
        }
      },
    );
  }
}
