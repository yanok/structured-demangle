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
    this(Kind k, string v)
    {
        kind = k;
        value = v;
    }

    this(Kind k, string v, Node[] ch)
    {
        this(k, v);
        children = ch;
    }

    static private string buildFactory(Kind k)
    {
        auto name = to!string(k);
        return "static " ~ name ~ "(string v) { return Node(Kind." ~ name ~ ", v); }\n" ~
            "static " ~ name ~ "(string v, Node[] ch) { return Node(Kind." ~ name ~ ", v, ch); }";
    }

    static foreach (k; EnumMembers!Kind)
    {
        mixin(buildFactory(k));
    }

}
