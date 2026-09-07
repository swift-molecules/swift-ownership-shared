public import Cardinal_Standard_Library_Integration
public import Cardinal_Carrier
public import Cardinal_Tagged
public import Cardinal
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Index
public import Tagged
public import Memory_Small
public import Memory_Allocator_Protocol
public import Buffer_Protocol
public import Store_Protocol
public import Store
public import Buffer
public import Buffer_Ring_Bounded_Primitive
public import Buffer_Ring_Primitive
public import Memory_Allocator
public import Memory
public import Ownership
public import Storage

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ buffer: consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring {
        self.init(box: Ownership.Box(buffer, drain: { $0.removeAll() }))
    }

    @inlinable
    public init(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Bounded {
        self.init(box: Ownership.Box(buffer, drain: { $0.remove.all() }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ buffer: consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.removeAll() },
                clone: { $0.clone() }
            )
        )
    }

    @inlinable
    public init(
        _ buffer:
            consuming Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring
            .Bounded
    )
    where B == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Ring.Bounded {
        self.init(
            box: Ownership.Box(
                buffer,
                drain: { $0.remove.all() },
                clone: { $0.clone() }
            )
        )
    }
}
