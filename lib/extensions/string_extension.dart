/// A simple extension to print out the platform
extension S on String {
  String replicate(int times) {
    var tmp = '';
    for(var i = 0; i < times; i++){
      tmp += this;
    }
    return tmp;
  }

  void printBox({String prefix = ''}) {
    print('-'.replicate(prefix.length + length + 4));
    print('| $prefix$this |');
    print('-'.replicate(prefix.length + length + 4));
  }
}