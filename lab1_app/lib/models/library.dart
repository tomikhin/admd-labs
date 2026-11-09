import 'library_item.dart';
import 'user.dart';

class Library {
  final List<LibraryItem> items = [];

  void addItem(LibraryItem item) {
    if (item.title.isNotEmpty) {
      items.add(item);
    }
  }

  List<LibraryItem> searchByTitle(String? query) {
    if (query == null || query.isEmpty) {
      return [];
    }
    return items
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<LibraryItem> getItemsByAuthor(String? authorName) {
    if (authorName == null || authorName.isEmpty) {
      return [];
    }
    return items
        .where((item) =>
            item.author != null &&
            item.author!.toLowerCase().contains(authorName.toLowerCase()))
        .toList();
  }

  List<LibraryItem> getRecentItems() {
    final nonNullDates = items.where((item) => item.publishDate != null).toList();
    nonNullDates.sort((a, b) => b.publishDate!.compareTo(a.publishDate!));
    return nonNullDates;
  }

  bool borrowItem(LibraryItem item, User borrowerUser, DateTime dueDate) {
    if (item.borrower != null) {
      return false;
    }
    item.borrower = borrowerUser;
    item.dueDate = dueDate;
    return true;
  }

  void returnItem(LibraryItem item) {
    item.borrower = null;
    item.dueDate = null;
  }
}