import Buffer
import Buffer_Linear
import Cardinal
import Index
import Memory
import Memory_Allocator
import Ownership_Shared_Primitive
import Storage
import Tagged
import Testing

@Suite
struct CanonicalContainerIntegrationTests {
    @Test
    func `Shared spells the CoW column over the heap backing`() {
        var a = Ownership.Shared<Int, Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear>(
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear(minimumCapacity: Tagged<Int, Cardinal>(Cardinal(UInt(4))))
        )
        a.withUnique { $0.append(1) }
        let b = a
        a.withUnique { $0.append(2) }
        #expect(a.count == 2)
        #expect(b.count == 1)
    }
}
