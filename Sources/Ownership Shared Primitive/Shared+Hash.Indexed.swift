public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Hash_Indexed_Primitive
import Hash
public import Memory_Allocator_Primitive
public import Memory
public import Ownership_Box
public import Storage_Contiguous
public import Storage_Primitive

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
        >, Element: Hash.Key & SendableMetatype
    {
        self.init(box: Ownership.Box(column, drain: { $0.removeAll(keepingCapacity: true) }))
    }
}

extension Ownership.Shared where Element: Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
        >, Element: Hash.Key & SendableMetatype
    {
        self.init(
            box: Ownership.Box(
                column,
                drain: { $0.removeAll(keepingCapacity: true) },
                clone: { $0.clone() }
            )
        )
    }
}
