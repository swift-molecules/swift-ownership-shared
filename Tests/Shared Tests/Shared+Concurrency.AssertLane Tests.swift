import Tagged
import Ordinal_Cardinal
import Ordinal_Tagged
import Ordinal
import Cardinal
import Cardinal_Tagged
import Cardinal
import Tagged
public import Memory_Small
#if DEBUG

    import Ownership_Shared_Primitive
    import Buffer
    import Buffer_Linear_Primitive
    import Storage
    import Memory
    import Memory_Allocator
    import Index
    import Testing

    private typealias HeapColumn<E: ~Copyable> =
        Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
    private typealias SharedColumn<E: ~Copyable> = Ownership.Shared<E, HeapColumn<E>>

    private func makeShared<E>(capacity: UInt) -> SharedColumn<E> {
        SharedColumn<E>(HeapColumn<E>(minimumCapacity: Tagged<E, Cardinal>(capacity)))
    }

    @Suite
    struct `Shared Assert Lane Death Tests` {

        @Test
        func `appendAssumingUnique on a shared box dies in debug`() async {
            await #expect(processExitsWith: .failure) {
                var a: SharedColumn<Int> = makeShared(capacity: 4)
                a.append(1)
                let b = a
                a.appendAssumingUnique(2)
                _ = b
            }
        }

        @Test
        func `removeLastAssumingUnique on a shared box dies in debug`() async {
            await #expect(processExitsWith: .failure) {
                var a: SharedColumn<Int> = makeShared(capacity: 4)
                a.append(1)
                let b = a
                _ = a.removeLastAssumingUnique()
                _ = b
            }
        }

        @Test
        func `withMutableSpanAssumingUnique on a shared box dies in debug`() async {
            await #expect(processExitsWith: .failure) {
                var a: SharedColumn<Int> = makeShared(capacity: 4)
                a.append(1)
                let b = a
                a.withMutableSpanAssumingUnique { span in
                    span[0] = 99
                }
                _ = b
            }
        }

        @Test
        func `assumingUnique spellings succeed on a truly unique box`() {
            var a: SharedColumn<Int> = makeShared(capacity: 4)
            a.appendAssumingUnique(1)
            a.appendAssumingUnique(2)
            a.withMutableSpanAssumingUnique { span in
                span[0] = 10
            }
            let last = a.removeLastAssumingUnique()
            #expect(last == 2)
            let first = a[.zero]
            #expect(first == 10)
            let n = a.count
            #expect(n == Tagged<Int, Cardinal>(1))
        }

        @Test
        func `the gate restores uniqueness so a post-detach assumingUnique is lawful`() {
            var a: SharedColumn<Int> = makeShared(capacity: 4)
            a.append(1)
            let b = a
            a.ensureUnique()
            a.appendAssumingUnique(2)
            let aCount = a.count
            let bCount = b.count
            #expect(aCount == Tagged<Int, Cardinal>(2))
            #expect(bCount == Tagged<Int, Cardinal>(1))
        }
    }

#endif
