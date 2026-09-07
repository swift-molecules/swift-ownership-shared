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
public import Buffer
public import Store
import Affine_Standard_Library_Integration
public import Index
import Ordinal_Standard_Library_Integration

extension Ownership.Shared: Equatable where Element: Equatable, B: ~Copyable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        var slot: Index<Element> = .zero
        let end = lhs.count.map(Ordinal.init)
        while slot < end {
            guard lhs[slot] == rhs[slot] else { return false }
            slot += .one
        }
        return true
    }
}
