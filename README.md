# Overview

A shopping list application that asynchronously syncs data to the cloud to persist data between sessions on a user's device.

Purpose:
To understand how cloud databases integrate into applications and specifically how they can allow for rapid prototyping.

[Software Demo Video](https://www.loom.com/share/f2e2ed619fb04a6eae89663b2a52e09c)

# Cloud Database

Firebase Firestore

Schema:

ShoppingLists

| attribute | type                  |
| --------- | --------------------- |
| name      | string                |
| createdAt | timestamp             |
| ownerId   | string                |
| items     | array of ShoppingItem |

ShoppingItem

| attribute | type      |
| --------- | --------- |
| name      | string    |
| addedAt   | timestamp |
| isChecked | boolean   |
| checkedAt | timestamp |


# Development Environment

## Tools
* XCode
* MacOS

## Language
* Swift
* SwiftUI
* SwiftData

# Useful Websites

- [Firebase documentation](https://firebase.google.com/docs/firestore)
- [Firestore iOS codelab](https://firebase.google.com/codelabs/firestore-ios#0)

# Future Work

- Explicit user authentication, rather than anonymous authentication
- Better error handling, maybe adding a bug capturing service
