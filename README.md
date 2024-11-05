# shoply
An e-commerce application designed for single-store use, allowing users to browse, select, and order products conveniently.

## Description
Shoply is an e-commerce platform for private stores, enabling store owners to engage customers online with flexible payment options, including Cash on Delivery and Online Payment.

## Features
- **User Authentication**: Login, Sign-Up, Firebase Email Verification
- **Product Management**: Search and order products
- **User Account Management**: Change password, upload profile image
- **Flexible Payment Options**: Cash on Delivery and Online Payment
- **Order Management**: Cancel orders, track delivery status, and verify order delivery


## Setup Instructions
1. Clone this repository.
2. Navigate to project directory 'cd shoply'.
3. Configure all the settings e.g: create .env file in the root of folder of the app, and also place your google-services.json file, place your api_key in .env, provided in your google-services.json file.
4. install dependencies 'flutter pub get'.
5. Configure your Stripe key and in the main function, place it .env file and also authorization key in lib/stripe_helper/stripe_helper.dart.
6. Run the flutter app "flutter run".
