import 'package:equatable/equatable.dart';

import '../models/fees_models.dart';

/// Whether the typed card fields look complete enough to offer Pay.
///
/// Format checks only — nothing here talks to a gateway, and nothing is
/// stored. A real PSP will replace these with its own SDK.
enum CardFieldProblem {
  /// Card number is empty or shorter than a PAN.
  cardNumber,

  /// Expiry is not `MM/YY`.
  expiry,

  /// CVV is not three or four digits.
  cvv,

  /// PIN is empty or shorter than four digits.
  pin,
}

/// State of one visit to the card checkout.
class FeeCardCheckoutState extends Equatable {
  const FeeCardCheckoutState({
    this.session,
    this.cardNumber = '',
    this.expiry = '',
    this.cvv = '',
    this.pin = '',
    this.saveCard = true,
  });

  /// `null` until the visit starts from the university checkout's choices.
  final CardCheckoutSession? session;

  final String cardNumber;
  final String expiry;
  final String cvv;
  final String pin;
  final bool saveCard;

  bool get isStarted => session != null;

  /// Digits only from [cardNumber].
  String get cardDigits => cardNumber.replaceAll(RegExp(r'\D'), '');

  CardFieldProblem? get problem {
    if (!isStarted) return CardFieldProblem.cardNumber;
    if (cardDigits.length < 13) return CardFieldProblem.cardNumber;
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry.trim())) {
      return CardFieldProblem.expiry;
    }
    if (!RegExp(r'^\d{3,4}$').hasMatch(cvv.trim())) {
      return CardFieldProblem.cvv;
    }
    if (!RegExp(r'^\d{4,}$').hasMatch(pin.trim())) {
      return CardFieldProblem.pin;
    }
    return null;
  }

  bool get canPay => isStarted && problem == null;

  /// Reference the return screen should open after Pay.
  String? get transactionReference => session?.transactionReference;

  FeeCardCheckoutState copyWith({
    CardCheckoutSession? session,
    String? cardNumber,
    String? expiry,
    String? cvv,
    String? pin,
    bool? saveCard,
  }) {
    return FeeCardCheckoutState(
      session: session ?? this.session,
      cardNumber: cardNumber ?? this.cardNumber,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      pin: pin ?? this.pin,
      saveCard: saveCard ?? this.saveCard,
    );
  }

  @override
  List<Object?> get props => [session, cardNumber, expiry, cvv, pin, saveCard];
}
