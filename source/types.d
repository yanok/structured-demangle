module types;

import std.conv;
import std.range;
import std.traits;

struct Node
{
    enum Kind
    {
        NonMangled,
        CxxMangled,
        DMangled,
        MangledName,
        QualifiedName,
        FunctionTypeNoReturn,
        SymbolName,
        TemplateInstance,
        TemplateName,
        TemplateArguments,
        Value,
        FunctionArguments,
        Type
    }

    Kind kind;
    string value;
    Node[] children;
    this(Kind k) nothrow pure @safe
    {
        kind = k;
    }

    this(Kind k, string v) nothrow pure @safe
    {
        this(k);
        value = v;
    }

    this(Kind k, string v, Node[] ch) nothrow pure @safe
    {
        this(k, v);
        children = ch;
    }
}
