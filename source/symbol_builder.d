module symbol_builder;

import std.exception;
import std.range;
import std.string;

import types;

struct SymbolBuilder
{
    Node[][] stack;

    void start()
    {
        enforce(stack.length == 0, "Stack must be empty in the beginning");
        stack ~= [[]];
    }

    Node end()
    {
        auto r = stack.back.back;
        stack.popBack;
        return r;
    }

    void enter(Node.Kind node) nothrow pure @safe
    {
        stack.back ~= Node(node);
        stack ~= [[]];
    }

    void exit(char[] result) nothrow pure @safe
    {
        auto children = stack.back;
        stack.popBack;
        if (result != "")
        {
            auto r = result.idup;
            stack.back.back.value = r;
            if (!children.empty)
                stack.back.back.children = children;
        }
        else if (stack.back.length > 1)
        {
            stack.back.popBack;
        }
    }

}
