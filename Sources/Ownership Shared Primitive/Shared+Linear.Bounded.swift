public import Buffer_Linear_Bounded_Primitive
public import Buffer_Linear_Primitive
public import Buffer
public import Memory_Allocator
public import Memory
public import Ownership_Box
public import Storage

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
