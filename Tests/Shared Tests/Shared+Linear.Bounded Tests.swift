import Buffer
import Buffer_Linear_Bounded_Primitive
import Buffer_Linear_Primitive
import Buffer_Test_Support
import Cardinal
import Carrier
import Index
import Memory
import Memory_Allocator
import Memory_Small
import Ordinal
import Ownership_Shared_Primitive
import Property
import Storage
import Tagged
import Testing

private typealias HeapStorage<E: ~Copyable> =
    Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>

private typealias BoundedLinear<E: ~Copyable> = Buffer<HeapStorage<E>>.Linear.Bounded

private typealias SharedBoundedLinear<E: ~Copyable> = Ownership.Shared<E, BoundedLinear<E>>

@Suite
struct `Shared Linear Bounded Law Tests` {

    @Test
    func `the shared bounded-linear column obeys the seam ledger laws`() {
        let violations = Seam.Ledger.violations(
            makeEmpty: {
                SharedBoundedLinear<Int>(BoundedLinear<Int>(minimumCapacity: Tagged<Int, Cardinal>(4)))
            },
            element: { $0 }
        )
        #expect(violations.isEmpty, "\(violations)")
    }
}

@Suite(.serialized)
struct `Shared Linear Bounded CoW Tests` {

    @Test
    func `copies share the box; a gated write detaches with capacity preserved exactly`() {
        var s = SharedBoundedLinear<Int>(BoundedLinear<Int>(minimumCapacity: Tagged<Int, Cardinal>(4)))
        s.initialize(at: 0, to: 1)
        s.initialize(at: 1, to: 2)
        let capacityBefore = s.capacity
        let t = s
        let sharedBefore = (s._boxID == t._boxID)
        #expect(sharedBefore)
        s[0] = 100
        let diverged = (s._boxID != t._boxID)
        #expect(diverged)
        #expect(s.capacity == capacityBefore)
        let mine = s[0]
        let theirs = t[0]
        #expect(mine == 100)
        #expect(theirs == 1)
    }

    @Test
    func `a move-only bounded column drains through the box deinit`() {
        BoundedProbe.reset()
        do {
            var s = SharedBoundedLinear<BoundedItem>(
                BoundedLinear<BoundedItem>(minimumCapacity: Tagged<BoundedItem, Cardinal>(2))
            )
            s.initialize(at: 0, to: BoundedItem(7))
            s.initialize(at: 1, to: BoundedItem(8))
            let n = s.count
            #expect(n == Tagged<BoundedItem, Cardinal>(2))
        }
        let all = BoundedProbe.destroyedSorted
        #expect(all == [7, 8])
    }
}

private struct BoundedItem: ~Copyable {
    let id: Int
    init(_ id: Int) { self.id = id }
    deinit { BoundedProbe.recordDestroy(id) }
}

private enum BoundedProbe {}

extension BoundedProbe {
    nonisolated(unsafe) static var _destroyed: [Int] = []
    static func reset() { unsafe _destroyed = [] }
    static func recordDestroy(_ id: Int) { unsafe _destroyed.append(id) }
    static var destroyedSorted: [Int] { unsafe _destroyed.sorted() }
}
