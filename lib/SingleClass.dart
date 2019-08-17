class SingleClass {
  static SingleClass _instance;

  StringBuffer title = StringBuffer()..write('Flutter Demo Home Page');

  SingleClass._();

  static SingleClass getInstance() {
    if (_instance == null) {
      _instance = SingleClass._();
    }
    return _instance;
  }
}
