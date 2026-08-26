public import Buffer_Linear_Primitive
public import Buffer_Primitive
public import Hash_Indexed_Primitive
import Hash_Primitive
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitive
public import Ownership_Box_Primitive
public import Storage_Contiguous_Primitive
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
