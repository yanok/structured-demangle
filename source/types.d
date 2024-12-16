module types;

abstract class Node
{
    string value;
    Node[] children;
}

final class NonMangled : Node
{
}

final class CxxMangled : Node
{
}

final class DMangled : Node
{
}

final class MangledName : Node
{
}

final class QualifiedName : Node
{
}

final class FunctionTypeNoReturn : Node
{
}

final class SymbolName : Node
{
}

final class TemplateInstance : Node
{
}

final class TemplateName : Node
{
}

final class TemplateArguments : Node
{
}

final class Value : Node
{
}

final class FunctionArguments : Node
{
}

final class Type : Node
{
}
