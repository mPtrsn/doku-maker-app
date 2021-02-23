class Config {
  static final bool useLocalhost = false;
  static String get backendURL {
    return Config.useLocalhost
        ? 'http://10.0.2.2:3000'
        : 'https://api.twistways.com';
  }

  static final bool useAuth = true;
  static final String localAuthName = 'stec102359';

  static final String couchdbURL = 'https://couchdb.twistways.com';
  static final String smartareaID = '600710d4df5504a1e33a1887';
  static final String defaultImagePath =
      '/images/9277d24b4a1f72cf4c20a4b9900025e3/i.png';
}
