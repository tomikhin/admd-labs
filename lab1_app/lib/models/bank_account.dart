class BankAccount {
  late String accountNumber;
  final String holderName;
  double balance;
  final String? bankBranch;

  BankAccount({
    required this.holderName,
    this.balance = 0.0,
    this.bankBranch,
  });
  
  void initializeAccount(String number) {
    accountNumber = number;
  }
  
  bool isAccountNumberSet() {
    try {
      _checkAccountInitialized();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _checkAccountInitialized() {
    // String tempAccountNumber = accountNumber;
  }
}