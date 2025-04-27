const authUrl = 'https://auth.literotica.com/';
const apiUrl = 'https://literotica.com/api/3/';
const apiUrlV1 = 'https://literotica.com/api/1/';
const litUrl = 'https://literotica.com/';

const app_id = '24b7c3f9d904ebd679299b1ce5506bc305a5ab40';
const api_key = '70b3a71911b398a98d3dac695f34cf279c270ea0';

enum LoginState { loggedOut, loading, loggedIn, failure }

enum SearchSortField { relevant, dateAsc, dateDesc, voteAsc, voteDesc, commentsAsc, commentsDesc }

class SearchString {
  // ignore: constant_identifier_names
  static const String? relevant = null;
  // ignore: constant_identifier_names
  static const String dateAsc = 'date asc';
  // ignore: constant_identifier_names
  static const String dateDesc = 'date desc';
  // ignore: constant?_identifier_names
  static const String voteAsc = 'vote asc';

  // ignore: constant?_identifier_names
  static const String voteDesc = 'vote desc';
  // ignore: constant?_identifier_names
  static const String commentsAsc = 'comments asc';
  // ignore: constant?_identifier_names
  static const String commentsDesc = 'comments desc';
}
