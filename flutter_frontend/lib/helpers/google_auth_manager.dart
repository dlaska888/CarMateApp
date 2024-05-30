import 'dart:developer';

import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/helpers/api_endpoints.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleAuthManager {
  Future<bool> loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '102794300888-of05afkrqcrmk8i7l2m9448ecc03dbgl.apps.googleusercontent.com',
      scopes: ['email', 'profile'],
    );

    try {
      await googleSignIn.currentUser?.clearAuthCache();
      var result = await googleSignIn.signInSilently();
      result ??= await googleSignIn.signIn();

      if (result == null) {
        return false;
      }

      var googleKey = await result.authentication;

      if (googleKey.idToken == null) {
        return false;
      }

      var tokens =
          await ApiClient.sendRequest("${ApiEndpoints.baseUrl}/login-google",
              methodFun: http.post,
              body: {
                'idToken': googleKey.idToken,
              },
              authorizedRequest: false);

      await ApiClient.login(tokens['token'], tokens['refreshToken']);
      return true;
    } catch (error) {
      log('Error occurred!', error: error, stackTrace: StackTrace.current);
      return false;
    }
  }
}
