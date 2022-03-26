# Collections

- [**Users**](#users)
- [**Chats**](#chats)
  - [**Messages**](#messages)

## Users

### Document Fields

- id (custom id)
- username
- token (device token for push notification)

## Chats

### Document Fields

- users (senderIdValue: null, receiverIdValue: null)
- messages (**inner collection**)

## Messages

### Document Fields

- createdOn
- uid (user document id)
- messageText

---

# Lists in App

- Chat list
- Message list
- Random user list maybe
