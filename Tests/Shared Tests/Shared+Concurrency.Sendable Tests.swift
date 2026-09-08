import Tagged
import Ordinal_Cardinal
import Ordinal_Tagged
import Ordinal
import Cardinal
import Cardinal_Tagged
import Cardinal
import Tagged
public import Memory_Small
import Buffer_Linear_Bounded_Primitive
import Buffer_Linear_Primitive
import Buffer
import Index
import Memory_Allocator
import Memory
import Ownership_Shared_Primitive
import Storage
import Testing

private typealias HeapColumn<E: ~Copyable> =
    Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
private typealias SharedColumn<E: ~Copyable> = Ownership.Shared<E, HeapColumn<E>>
private typealias BoundedColumn<E: ~Copyable> =
    Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear.Bounded
private typealias SharedBounded<E: ~Copyable> = Ownership.Shared<E, BoundedColumn<E>>

private func makeShared<E>(capacity: UInt) -> SharedColumn<E> {
    SharedColumn<E>(HeapColumn<E>(minimumCapacity: Tagged<E, Cardinal>(capacity)))
}

private func makeSharedMoveOnly<E: ~Copyable>(capacity: UInt) -> SharedColumn<E> {
    SharedColumn<E>(HeapColumn<E>(minimumCapacity: Tagged<E, Cardinal>(capacity)))
}

private struct Item: ~Copyable, Sendable {
    let id: Int
    init(_ id: Int) { self.id = id }
}

@Suite
struct `Shared Sendable Surface Tests` {

    @Test
    func `sendable composes across columns and rungs`() {
        let heap: SharedColumn<Int> = makeShared(capacity: 1)
        requireSendable(heap)
        let bounded = SharedBounded<Int>(BoundedColumn<Int>(minimumCapacity: Tagged<Int, Cardinal>(1)))
        requireSendable(bounded)

        let moveOnly: SharedColumn<Item> = makeSharedMoveOnly(capacity: 1)
        requireSendable(moveOnly)
        let n = moveOnly.count
        #expect(n == Tagged<Item, Cardinal>(0))
        #expect(Bool(true))
    }
}

private func requireSendable<T: Sendable & ~Copyable>(_ value: borrowing T) {}
