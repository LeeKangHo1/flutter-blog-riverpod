({String username, int password}) hello() {
  return (username: "ssar", password: 1234);
}

void main() {
  var n = hello();
  print(n.username);
  print(n.password);
}
