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

  Future<AuthService> init() async {
    currentUser.value = _firebaseAuth.currentUser;
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
}
