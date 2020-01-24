/// A simple extension to print out the platform
extension S on String {
  String replicate(int times) {
    var tmp = '';
    for(var i = 0; i < times; i++){
      tmp += this;
    }
    return tmp;
  }

  String toBox({String prefix = ''}) {
    var tmp = '';
    tmp += '-'.replicate(prefix.length + length + 4) + '\n';
    tmp += '| $prefix$this |\n';
    tmp +='-'.replicate(prefix.length + length + 4) + '\n';
    return tmp;
  }

  void printBox({String prefix = ''}) => print(toBox(prefix: prefix));
}