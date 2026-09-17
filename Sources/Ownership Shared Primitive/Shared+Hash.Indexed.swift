public import Cardinal
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
public import Buffer
public import Store
public import Buffer_Linear_Primitive
public import Hash_Indexed_Primitive
public import Memory_Allocator
public import Memory
public import Ownership
public import Storage

extension Ownership.Shared where Element: ~Copyable, B: ~Copyable {

    @inlinable
    public init(
        _ column:
            consuming Hash.Indexed<
                Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear
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
                Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear
            >
    )
    where
        B == Hash.Indexed<
            Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear
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
