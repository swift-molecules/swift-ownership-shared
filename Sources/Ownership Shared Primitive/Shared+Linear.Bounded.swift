public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Memory_Allocator_Primitive
public import Memory_Heap
public import Ownership_Box
public import Storage_Contiguous

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Bounded {
        self.init(box: Ownership.Box(buffer, drain: { $0.remove.all() }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Bounded {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.remove.all() },
                clone: { $0.clone() }
            )
        )
    }
}
