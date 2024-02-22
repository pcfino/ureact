import 'api_util.dart' as api;
import 'dart:convert';


/// Makes a request to sign up a new User
///
/// @param userData: Object containing all needed information
/// to sign up a new user: First Name, Last Name, Username, Email, Password
/// 
///
/// @return True if user can now sign in, false if user needs to confirm sign in
/// or error if action failed
Future signUpUser(Map userData) async {
  try {
    var results = await api.post('/signUp', userData);
    return await jsonDecode(results);
  } catch (err) {
    return {"status": "error"};
  }
}

/// Confirms a new user
///
/// @param userConfirmation: Object containing all needed information
/// to confrim User: Username, Confirmation Code
/// 
///
/// @return True if user can now sign in, false if user confirmation failed in
/// or error if action failed
Future confirmSignUp(Map userConfirmation) async {
  try {
    var results = await api.post('/confirmSignUp', userConfirmation);
    return await jsonDecode(results);
  } catch (err) {
    return {"status": "error"};
  }
}

/// User Login
///
/// @param loginCredintials: Object containing all needed information
/// to login: Username, password
/// 
///
/// @return True if user can now sign in, false if user confirmation failed in
/// or error if action failed
Future logIn(Map loginCredintials) async {
  try {
    var results = await api.post('/signIn', loginCredintials);
    return await jsonDecode(results);
  } catch (err) {
    return {"status": "error"};
  }
}

/// Makes request to get all users
///
/// @return Json object with the patients info
Future getUsers() async {
  var results = await api.get('/getUsers');
  return jsonDecode(results);
}