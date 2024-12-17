module structured_demangle;

import imported.core.demangle;
import symbol_builder;
import types;

Node structuredDemangle(return scope const(char)[] buf, return scope char[] dst = null, CXX_DEMANGLER __cxa_demangle = null)
{
    if (__cxa_demangle && buf.length > 2 && buf[0 .. 2] == "_Z")
    {
        auto res = demangleCXX(buf, __cxa_demangle, dst);
        return Node(Node.Kind.CxxMangled, cast(string) res);
    }
    auto d = Demangle!(SymbolBuilder)(buf, dst);
    d.hooks.start;
    // fast path (avoiding throwing & catching exception) for obvious
    // non-D mangled names
    if (buf.length < 2 || !(buf[0] == 'D' || buf[0 .. 2] == "_D"))
    {
        auto res = d.dst.copyInput(buf).idup;
        return Node(Node.Kind.NonMangled, res);
    }
    auto demangled = d.demangleName().idup;
    if (demangled == buf)
    {
        return Node(Node.Kind.NonMangled, demangled);
    }
    auto res = d.hooks.end;
    assert(res.value == demangled);
    return res;
}

unittest
{
    Node[string] examples =
        [
            "_D3std6getopt__TQkTAyaTDFNaNbNiNfQoZvTQtTDQsZQBnFNfKAQBiQBlQBkQBrQyZSQCpQCo12GetoptResult": Node(
                Node.Kind.MangledName,
                "@safe std.getopt.GetoptResult std.getopt.getopt!(immutable(char)[], void delegate(immutable(char)[]) pure nothrow @nogc @safe, "
                    ~ "immutable(char)[], void delegate(immutable(char)[]) pure nothrow @nogc @safe)."
                    ~ "getopt(ref immutable(char)[][], immutable(char)[], void delegate(immutable(char)[]) pure nothrow @nogc @safe, "
                    ~ "immutable(char)[], void delegate(immutable(char)[]) pure nothrow @nogc @safe)",
                [
                Node(Node.Kind.FunctionTypeNoReturn, "@safe (ref immutable(char)[][], immutable(char)[], void delegate(immutable(char)[]) pure nothrow @nogc @safe, immutable(char)[], void delegate(immutable(char)[]) pure nothrow @nogc @safe)"),
                Node(Node.Kind.QualifiedName, "std.getopt.GetoptResult")
            ]
            ),
            "_D3std5regex8internal9kickstart__T7ShiftOrTaZQl11ShiftThread__T3setS_DQCqQCpQCmQCg__TQBzTaZQCfQBv10setInvMaskMFNaNbNiNfkkZvZQCjMFNaNfwZv": Node(
                Node.Kind.MangledName,
                "pure @safe void std.regex.internal.kickstart.ShiftOr!(char).ShiftOr.ShiftThread.set!(std.regex.internal.kickstart.ShiftOr!(char).ShiftOr.ShiftThread.setInvMask(uint, uint)).set(dchar)",
                [
                Node(
                    Node.Kind.MangledName,
                    "std.regex.internal.kickstart.ShiftOr!(char).ShiftOr.ShiftThread.setInvMask(uint, uint)", [
                    Node(Node.Kind.FunctionTypeNoReturn, "(uint, uint)")
                ]),
                Node(Node.Kind.FunctionTypeNoReturn,
                    "pure @safe (dchar)")
            ]
            )
    ];

    import std.format;

    foreach (s, r; examples)
    {
        auto res = structuredDemangle(s);
        assert(res.kind == Node.Kind.MangledName);
        assert(res == r, format("\nExpected:\t%s\nGot     :\t%s", r, res));
    }
}
