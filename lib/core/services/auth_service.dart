import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'purchase_service.dart';

/// Centraliza login/logout e expõe o usuário atual como estado reativo (GetX).
///
/// Ponto importante: sempre que o usuário loga ou desloga, este serviço avisa
/// o PurchaseService pra sincronizar o `uid` com o RevenueCat
/// (Purchases.logIn / Purchases.logOut). É isso que amarra o Premium à conta
/// do usuário, e não ao aparelho.
class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<User?> currentUser = Rx<User?>(null);

  bool get isLoggedIn => currentUser.value != null;

  /// Diferente de `isLoggedIn`: "Continuar sem login" também cria um usuário
  /// no Firebase (anônimo), então `isLoggedIn` sozinho não serve pra saber
  /// se a pessoa tem uma conta Google de verdade vinculada.
  bool get isGoogleLinked =>
      currentUser.value != null && !currentUser.value!.isAnonymous;

  Future<AuthService> init() async {
    try {
      currentUser.value = await _firebaseAuth.authStateChanges().first;
    } catch (_) {
      currentUser.value = _firebaseAuth.currentUser;
    }

    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
    return this;
  }

  Future<void> _onAuthStateChanged(User? user) async {
    currentUser.value = user;
    final purchaseService = Get.find<PurchaseService>();
    if (user != null) {
      // Amarra o entitlement do RevenueCat a este uid específico.
      await purchaseService.linkToUser(user.uid);
    } else {
      await purchaseService.unlinkUser();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // usuário cancelou

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _firebaseAuth.signInWithCredential(credential);
  }

  /// Login anônimo: permite usar o app free sem forçar cadastro logo de cara.
  /// Se depois o usuário assinar Premium, vale oferecer "vincular ao Google"
  /// pra não perder o acesso caso troque de aparelho.
  Future<UserCredential?> signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  /// Exclui a conta do Firebase Auth (exigência do Google Play pra apps que
  /// permitem criar conta). Operações sensíveis como essa exigem login
  /// "recente" — se o Firebase reclamar disso, refaz o login do Google e
  /// tenta de novo, sem precisar pedir isso manualmente pro usuário toda vez.
  Future<void> excluirConta() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'requires-recent-login') rethrow;

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) rethrow; // usuário cancelou o reauth

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    }

    await _googleSignIn.signOut();
  }
}