namespace js Test.Something

exception MessageExistsException {
  /**
   * The error message
   */
  1: string message;
}

enum Operation {
  ADD = 1,
  SUBTRACT = 2,
  MULTIPLY = 3,
  DIVIDE = 4
}

const i32 INT32CONSTANT = 9853

typedef bool OperationTwo

struct Message {
  1: string text;
  2: string date;
}

service BulletinBoard {
  /**
   * Adds a new message.
   */
  void add(1: Message msg) throws (1:MessageExistsException messageExistsException);
  list<Message> get();
}

struct User {
  1: string name;
}

service UserService {
  /**
   * Adds a new message.
   */
  void add(1: User user)
  list<User> get();
}

