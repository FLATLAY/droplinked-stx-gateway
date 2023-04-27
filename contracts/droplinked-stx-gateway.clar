(define-data-var admin principal tx-sender)

(define-public 
  (pay-stx
    (amount uint)
    (sender principal)
    (recipient principal)
  )
  (let 
    (
      (fee (/ amount u100))
      (recipient-share (- amount fee))
    )
    (asserts! (is-eq sender tx-sender) (err u100))
    (asserts! (>= amount u100) (err u101))
    (asserts! (not (is-eq sender recipient)) (err u102))
    (try! (stx-transfer? (- amount fee) sender recipient))
    (try! (stx-transfer? fee sender (as-contract tx-sender)))
    (print 
      {
        event: "pay-stx",
        amount: amount,
        fee: fee,
        sender: sender,
        recipient: recipient
      }
    )
    (ok true)
  )
)
