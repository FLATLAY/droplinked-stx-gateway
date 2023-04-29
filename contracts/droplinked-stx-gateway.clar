(define-constant droplinked-key 0x032ee7469a745eff12fe3cc1802bdd5654211d3b93e09734a248c4ad42c038ac18)
(define-constant droplinked-admin (unwrap-panic (principal-of? droplinked-key)))

(define-constant err-sender-only (err u100))
(define-constant err-sender-is-recipient (err u101))

(define-constant err-amount-is-zero (err u200))

(define-public 
  (direct-pay
    (amount uint)
    (sender principal)
    (recipient principal)
  )
  (let 
    (
      (fee (/ amount u100))
    )
    (asserts! (is-eq sender tx-sender) err-sender-only)
    (asserts! (not (is-eq sender recipient)) err-sender-is-recipient)
    (asserts! (not (is-eq amount u0)) err-amount-is-zero)
    (try! (transfer-fee sender fee))
    (try! (stx-transfer? fee sender droplinked-admin))
    (print 
      {
        type: "direct-pay",
        amount: amount,
        fee: fee,
        sender: sender,
        recipient: recipient
      }
    )
    (ok true)
  )
)

(define-private 
  (transfer-fee
    (sender principal)
    (amount uint)
  )
  (if (is-eq amount u0) 
    (stx-transfer? amount sender droplinked-admin)
    (ok true)
  )
)
