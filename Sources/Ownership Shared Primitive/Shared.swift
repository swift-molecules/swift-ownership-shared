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
public import Memory_Allocator_Protocol
public import Store
public import Buffer_Protocol
public import Ownership_Box
public import Store_Protocol

extension Ownership {

    @frozen
    public struct Shared<
        Element: ~Copyable,
        B: Store.`Protocol` & Buffer.`Protocol` & ~Copyable
    >: ~Copyable where B.Element == Element {

        @usableFromInline
        internal var box: Ownership.Box<B>

        @usableFromInline
        internal init(box: consuming Ownership.Box<B>) {
            self.box = box
        }

        @usableFromInline
        package var _boxID: ObjectIdentifier { box.identity }
    }
}

extension Ownership.Shared: Copyable where Element: Copyable, B: ~Copyable {}

extension Ownership.Shared: Sendable where Element: ~Copyable, B: Sendable & ~Copyable {}
