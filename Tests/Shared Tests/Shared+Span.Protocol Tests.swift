import Buffer
import Buffer_Linear
import Buffer_Linear_Primitive
import Cardinal
import Carrier
import Index
import Memory
import Memory_Allocator
import Memory_Small
import Ordinal
import Ownership_Shared_Primitive
import Property
import Span
import Storage
import Tagged
import Testing

private typealias HeapStorage<E: ~Copyable> =
    Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>

private typealias HeapColumn<E: ~Copyable> = Buffer<HeapStorage<E>>.Linear
private typealias SharedColumn<E: ~Copyable> = Ownership.Shared<E, HeapColumn<E>>

private func total<S: Span.`Protocol`>(_ s: borrowing S) -> Int where S.Element == Int {
    var sum = 0
    let span = s.span
    for i in span.indices { sum &+= span[i] }
    return sum
}

@Suite(.serialized)
struct `Shared Span Protocol Tests` {

    @Test
    func `the laundered span reads the boxed column, directly and via the witness`() {
        var column = HeapColumn<Int>(minimumCapacity: Tagged<Int, Cardinal>(4))
        column.append(1)
        column.append(2)
        column.append(3)
        let s = SharedColumn<Int>(column)
        let direct = s.span
        #expect(direct.count == 3)
        var sum = 0
        for i in direct.indices { sum &+= direct[i] }
        #expect(sum == 6)
        #expect(total(s) == 6)
    }

    @Test
    func `the empty column vends the lawful empty window`() {
        let s = SharedColumn<Int>(HeapColumn<Int>(minimumCapacity: Tagged<Int, Cardinal>(2)))
        let span = s.span
        #expect(span.count == 0)
        #expect(total(s) == 0)
    }

    @Test
    func `a live span survives a sibling's gated detach-mutation unchanged`() {
        var column = HeapColumn<Int>(minimumCapacity: Tagged<Int, Cardinal>(4))
        column.append(1)
        column.append(2)
        column.append(3)
        let s = SharedColumn<Int>(column)
        var sibling = s
        let live = s.span
        sibling.append(99)
        var after = 0
        for i in live.indices { after &+= live[i] }
        #expect(after == 6)
        let siblingCount = sibling.count
        #expect(siblingCount == Tagged<Int, Cardinal>(4))
        let ourCount = s.count
        #expect(ourCount == Tagged<Int, Cardinal>(3))
    }
}
