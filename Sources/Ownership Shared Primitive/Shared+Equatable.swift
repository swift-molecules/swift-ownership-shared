import Affine_Primitive_Standard_Library_Integration
public import Index_Primitive
import Ordinal_Primitive_Standard_Library_Integration

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
