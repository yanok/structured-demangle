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
