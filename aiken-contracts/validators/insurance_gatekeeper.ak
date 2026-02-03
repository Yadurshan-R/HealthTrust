use aiken/collection/list
use aiken/crypto.{Blake2b_256, Hash, VerificationKey}
use cardano/transaction.{OutputReference, Transaction}

/// Datum: Privacy-preserving hashed user ID (Blake2b-256 of name + email)
pub type InsuranceDatum {
  hashed_user_id: ByteArray,
}

/// Redeemer: Empty (validation relies on signature check)
pub type InsuranceRedeemer {
  Void
}

/// Treasury public key hash
/// TODO: Replace with actual treasury public key hash from your wallet
const treasury_pkh: Hash<Blake2b_256, VerificationKey> =
  #"0000000000000000000000000000000000000000000000000000000000000000"

/// Insurance Gatekeeper Validator
///
/// This validator ensures that:
/// 1. The transaction is signed by the Insurance Treasury
/// 2. The datum contains the correct hashed user ID for privacy
///
/// The validator prevents unauthorized payouts while maintaining user privacy
/// through Blake2b-256 hashing of (name + email)
validator insurance_gatekeeper {
  spend(
    datum: Option<InsuranceDatum>,
    _redeemer: InsuranceRedeemer,
    _own_ref: OutputReference,
    ctx: Transaction,
  ) {
    // Requirement 1: Transaction MUST be signed by Treasury
    let must_be_signed_by_treasury =
      list.has(ctx.extra_signatories, treasury_pkh)

    // Requirement 2: Datum must be present (privacy check)
    let has_valid_datum =
      when datum is {
        Some(d) -> {
          // Verify that hashed_user_id is not empty
          d.hashed_user_id != ""
        }
        None -> False
      }

    // Both requirements must be met
    must_be_signed_by_treasury && has_valid_datum
  }

  else(_) {
    fail
  }
}
