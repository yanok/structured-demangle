module structured_demangle;

import imported.core.demangle;
import types;

Node structuredDemangle(return scope const(char)[] buf, return scope char[] dst = null, CXX_DEMANGLER __cxa_demangle = null)
{
    if (__cxa_demangle && buf.length > 2 && buf[0 .. 2] == "_Z")
    {
        auto res = demangleCXX(buf, __cxa_demangle, dst);
        return Node.CxxMangled(cast(string) res);
    }
    SymbolBuilder b = new SymbolBuilder();
    auto d = Demangle!()(buf, dst, b);
    // fast path (avoiding throwing & catching exception) for obvious
    // non-D mangled names
    if (buf.length < 2 || !(buf[0] == 'D' || buf[0 .. 2] == "_D"))
    {
        auto res = d.dst.copyInput(buf);
        return Node.NonMangled(res);
    }
    auto demangled = d.demangleName();
    if (demangled == buf)
    {
        return Node.NonMangled(demangled);
    }
    auto res = b.result;
    assert(res.value == demangled);
    return res;
}
