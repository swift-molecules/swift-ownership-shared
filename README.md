# swift-ownership-shared

Use this package to give a buffer column, such as a linear, bounded-linear, ring, bounded-ring, hash-indexed or generational store, copy-on-write value semantics. Copies are cheap, and each copy can be read or mutated independently, including from concurrent tasks. Start from `Ownership.Shared<Element, B>`, and build it from the column it should own. If you need copy-on-write over a single arbitrary value rather than a store with slots, use `Ownership.Box` from swift-ownership directly.

## Laws

- Copies share one backing. Reads never detach: the slot getter, `count`, `capacity`, `span`, `withSpan`, `withColumn` and the generational `contains` leave copies sharing, even under concurrent read traffic.
- Every gated mutation (the slot setter, `initialize`, `move`, `swapAt`, `unshare`, `append`, `removeLast`, `reserveCapacity`, `reallocate`, `withMutableSpan`, both `withUnique` forms, and the generational `insert`, `remove`, `grow` and handle setter) detaches before it writes. If the backing is shared, it clones the column into a fresh backing. If it is already unique, it mutates in place without cloning. `ensureUnique` returns `true` exactly when it cloned.
- A detach copies the column as it stands, and a bounded column keeps exactly its capacity. Siblings never see each other's writes after a detach.
- The `…AssumingUnique` members (`appendAssumingUnique`, `removeLastAssumingUnique`, `withMutableSpanAssumingUnique`) skip the gate. Calling one on a shared backing traps in debug builds only. In release builds it writes into the shared backing and every sibling sees the write. They are lawful after `ensureUnique`, and on a move-only `Element`, where `Ownership.Shared` is itself move-only and therefore always unique.
- `span` borrows the backing that is current at the moment of the call. A sibling's later detaching mutation does not change it. An empty column vends an empty span.
- Teardown: when the last copy sharing a backing ends, that backing destroys its live elements exactly once. A backing created by a detach destroys its own elements independently.
- `==` compares `count` and then the elements slot by slot. Capacity is ignored. `hash(into:)` hashes `count` and then each element in slot order, so equal values hash equally whether or not they share a backing.
