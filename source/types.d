module types;

import std.conv;
import std.range;
import std.traits;
import std.json;

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

    JSONValue toJSON()
    {
        import std.algorithm;

        return JSONValue([
            "Node": JSONValue(to!string(kind)),
            "Value": JSONValue(value),
            "children": JSONValue(children.map!(x => x.toJSON).array)
        ]);
    }
}
