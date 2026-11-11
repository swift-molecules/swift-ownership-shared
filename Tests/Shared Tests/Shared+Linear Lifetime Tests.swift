import Buffer
import Buffer_Linear_Primitive
import Cardinal
import Memory
import Memory_Allocator
import Memory_Small
import Ownership_Shared_Primitive
import Storage
import Tagged
import Testing

private final class Census {
    var destroyed: [Int] = []
}

private final class Member {
    let id: Int
    let census: Census

    init(_ id: Int, _ census: Census) {
        self.id = id
        self.census = census
    }

    deinit { census.destroyed.append(id) }
}

private struct Token: ~Copyable {
    let id: Int
    let census: Census

    deinit { census.destroyed.append(id) }
}

private typealias Column<E: ~Copyable> = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
private typealias SharedColumn<E: ~Copyable> = Ownership.Shared<E, Column<E>>

private func shared(of ids: Swift::Range<Int>, capacity: Int, _ census: Census) -> SharedColumn<Member> {
    var column = SharedColumn<Member>(
        Column<Member>(minimumCapacity: Tagged<Member, Cardinal>(_unchecked: Cardinal(UInt(capacity))))
    )
    ids.forEach { id in
        column.append(Member(id, census))
    }
    return column
}

enum `Shared+Linear Lifetime Tests` {}

extension `Shared+Linear Lifetime Tests` {
    @Suite
    struct `A shared linear buffer destroys its elements exactly once` {

        @Test(arguments: [0, 1, 5, 200])
        func `dropping the only copy destroys every element once`(count: Int) {
            let census = Census()
            do {
                let column = shared(of: 0..<count, capacity: 0, census)
                let untouched = census.destroyed.isEmpty
                #expect(untouched)
                _ = consume column
            }
            #expect(census.destroyed.sorted() == Array(0..<count))
        }

        @Test
        func `a buffer with room to spare destroys only the elements it holds`() {
            let census = Census()
            do {
                let column = shared(of: 0..<3, capacity: 64, census)
                _ = consume column
            }
            #expect(census.destroyed.sorted() == [0, 1, 2])
        }

        @Test
        func `the elements outlive every copy but the last`() {
            let census = Census()
            do {
                let first = shared(of: 0..<5, capacity: 0, census)
                do {
                    let second = first
                    _ = consume second
                }
                let alive = census.destroyed.isEmpty
                #expect(alive)
                _ = consume first
            }
            #expect(census.destroyed.sorted() == Array(0..<5))
        }

        @Test
        func `an element removed before the drop is destroyed by its new owner, the rest by the buffer`() {
            let census = Census()
            do {
                var column = shared(of: 0..<4, capacity: 0, census)
                let removed = column.removeLast()
                _ = consume column
                #expect(census.destroyed.sorted() == [0, 1, 2])
                #expect(removed.id == 3)
            }
            #expect(census.destroyed.sorted() == [0, 1, 2, 3])
        }

        @Test
        func `a removal from one of two copies detaches it, and each element is still destroyed once`() {
            let census = Census()
            do {
                let first = shared(of: 0..<5, capacity: 0, census)
                var second = first
                do {
                    let removed = second.removeLast()
                    #expect(removed.id == 4)
                }
                let alive = census.destroyed.isEmpty
                #expect(alive)
                _ = consume second
                let stillAlive = census.destroyed.isEmpty
                #expect(stillAlive)
                _ = consume first
            }
            #expect(census.destroyed.sorted() == Array(0..<5))
        }

        @Test
        func `a buffer reallocated to a new capacity destroys every element once`() {
            let census = Census()
            do {
                var column = shared(of: 0..<5, capacity: 8, census)
                column.reserveCapacity(Tagged<Member, Cardinal>(_unchecked: Cardinal(100)))
                column.reallocate(capacity: Tagged<Member, Cardinal>(_unchecked: Cardinal(16)))
                let alive = census.destroyed.isEmpty
                #expect(alive)
                _ = consume column
            }
            #expect(census.destroyed.sorted() == Array(0..<5))
        }

        @Test
        func `elements that cannot be copied are destroyed once when the buffer is dropped`() {
            let census = Census()
            do {
                var column = SharedColumn<Token>(Column<Token>(minimumCapacity: .zero))
                (0..<40).forEach { id in
                    column.appendAssumingUnique(Token(id: id, census: census))
                }
                let taken = column.removeLastAssumingUnique()
                _ = consume taken
                #expect(census.destroyed == [39])
                _ = consume column
            }
            #expect(census.destroyed.sorted() == Array(0..<40))
        }
    }
}
