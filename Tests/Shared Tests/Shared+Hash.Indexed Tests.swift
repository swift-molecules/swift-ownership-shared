import Buffer
import Buffer_Linear_Primitive
import Cardinal
import Hash_Indexed_Primitive
import Hash_Table_Primitive
import Index
import Memory
import Memory_Allocator
import Memory_Small
import Ordinal
import Ownership_Shared_Primitive
import Storage
import Tagged
import Testing

private final class Census {
    var destroyed: [Int] = []
}

private final class Member: Hashable {
    let id: Int
    let census: Census

    init(_ id: Int, _ census: Census) {
        self.id = id
        self.census = census
    }

    deinit { census.destroyed.append(id) }

    static func == (lhs: Member, rhs: Member) -> Bool { lhs.id == rhs.id }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

private struct Token: ~Copyable, Hashable {
    let id: Int
    let census: Census

    deinit { census.destroyed.append(id) }

    static func == (lhs: borrowing Token, rhs: borrowing Token) -> Bool { lhs.id == rhs.id }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

private typealias Column<E: Hashable & ~Copyable> =
    Hash.Indexed<Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear>

private func slot<E: ~Copyable & ~Escapable>(_ number: Int) -> Index<E> {
    Index<E>(_unchecked: Ordinal(UInt(number)))
}

private func column(
    of ids: Swift::Range<Int>,
    roomFor capacity: Int = 0,
    _ census: Census
) -> Column<Member> {
    var column = Column<Member>(minimumCapacity: Tagged<Member, Cardinal>(_unchecked: Cardinal(UInt(capacity))))
    ids.forEach { id in
        _ = column.insert(Member(id, census))
    }
    return column
}

enum `Shared+Hash.Indexed Tests` {}

extension `Shared+Hash.Indexed Tests` {
    @Suite
    struct `A shared hash indexed column destroys its members exactly once` {

        @Test(arguments: [0, 1, 5, 200])
        func `dropping the only copy destroys every member once`(count: Int) {
            let census = Census()
            do {
                let shared = Ownership.Shared(column(of: 0..<count, census))
                let untouched = census.destroyed.isEmpty
                #expect(untouched)
                _ = consume shared
            }
            #expect(census.destroyed.sorted() == Array(0..<count))
        }

        @Test
        func `the members outlive every copy but the last`() {
            let census = Census()
            do {
                let first = Ownership.Shared(column(of: 0..<5, census))
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
        func `a write to one of two copies detaches it, and each member is still destroyed once`() {
            let census = Census()
            do {
                let first = Ownership.Shared(column(of: 0..<5, census))
                var second = first
                do {
                    let removed = second.move(at: slot(4))
                    #expect(removed.id == 4)
                }
                #expect(first.count == Tagged<Member, Cardinal>(_unchecked: Cardinal(5)))
                #expect(second.count == Tagged<Member, Cardinal>(_unchecked: Cardinal(4)))
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
        func `a member moved out before the drop is destroyed by its new owner, the rest by the column`() {
            let census = Census()
            do {
                var shared = Ownership.Shared(column(of: 0..<4, census))
                let moved = shared.move(at: slot(3))
                _ = consume shared
                #expect(census.destroyed.sorted() == [0, 1, 2])
                #expect(moved.id == 3)
            }
            #expect(census.destroyed.sorted() == [0, 1, 2, 3])
        }

        @Test
        func `a column filled through the shared handle destroys every member once`() {
            let census = Census()
            do {
                var shared = Ownership.Shared(column(of: 0..<3, roomFor: 100, census))
                (3..<100).forEach { id in
                    shared.initialize(at: slot(id), to: Member(id, census))
                }
                let alive = census.destroyed.isEmpty
                #expect(alive)
                _ = consume shared
            }
            #expect(census.destroyed.sorted() == Array(0..<100))
        }

        @Test
        func `members that cannot be copied are destroyed once when the column is dropped`() {
            let census = Census()
            do {
                var column = Column<Token>(minimumCapacity: .zero)
                (0..<5).forEach { id in
                    _ = column.insert(Token(id: id, census: census))
                }
                let shared = Ownership.Shared(column)
                let alive = census.destroyed.isEmpty
                #expect(alive)
                _ = consume shared
            }
            #expect(census.destroyed.sorted() == Array(0..<5))
        }
    }
}
