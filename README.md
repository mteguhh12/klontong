# klontong

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build

use fvm version 3.24.5

## To build APK:

fvm flutter build apk --no-tree-shake-icons

## In order to build for production environment, append these to any of above command:

--dart-define="KLONTONG_ENV=PRODUCTION"

## Database:

online CRUD backend: https://mockapi.io
url api: https://mockapi.io/projects/68e09dd093207c4b4794e4b0

category
{
"id": "string",
"name": "string",
}

product
{
"id": "string",
"categoryId": "relation of category",
"sku": "string",
"name": "string",
"description": "string",
"weight": "number",
"image": "string",
"price": "number",
"category": "parent resource"
}
