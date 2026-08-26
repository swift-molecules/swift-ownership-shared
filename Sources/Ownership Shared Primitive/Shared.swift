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
