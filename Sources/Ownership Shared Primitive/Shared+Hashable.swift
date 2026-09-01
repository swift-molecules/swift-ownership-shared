public import Cardinal_Standard_Library_Integration
public import Cardinal_Carrier
public import Cardinal_Tagged
public import Cardinal
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Ordinal_Tagged
public import Ordinal
public import Tagged
public import Memory_Allocator_Protocol
public import Buffer_Protocol
public import Store_Protocol
public import Store
import Affine_Standard_Library_Integration
public import Index
import Ordinal_Standard_Library_Integration

extension Ownership.Shared: Hashable where Element: Hashable, B: ~Copyable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(bitPattern: count.underlying))
        var slot: Index<Element> = .zero
        let end = count.map(Ordinal.init)
        while slot < end {
            hasher.combine(self[slot])
            slot += .one
        }
    }
}
