"""
HPMS Lua statement builder.

"""

from hpms_lua_script_data import LuaStatement, LuaFieldType

from enum import Enum


def strv(ftype, value):
    if ftype is LuaFieldType.STRING:
        return '\'' + str(value) + '\''
    else:
        return str(value)


class LuaAssignmentOperator(Enum):
    SET = '='
    INCR = '+='
    DECR = '-='
    INCR_M = '*='
    DECR_D = '/='


class LuaUnaryOperator(Enum):
    NOT = 'not'
    NEGATE = '-'
    LENGTH = '#'


class LuaLogicalOperator(Enum):
    AND = 'and'
    OR = 'or'


class LuaBinaryOperator(Enum):
    EQ = '=='
    GT = '>'
    GE = '>='
    LT = '<'
    LE = '<='
    NOT_EQ = '~='


class LuaStatementBuilder:
    def __init__(self):
        self.statement = LuaStatement('')
        self.indent = ''
        self.brackets_count = 0
        self.opened_if = 0

    def add_indent(self):
        self.indent += '    '

    def rem_indent(self):
        if len(self.indent) >= 4:
            self.indent = self.indent[:-4]

    def validate(self):
        check = True
        check &= self.brackets_count == 0
        check &= self.opened_if == 0
        if not check:
            raise ValueError('Lua statement validation failed.')

    def build(self):
        self.validate()
        return self.statement

    def reset(self):
        self.statement = LuaStatement('')
        return self

    def nl_s(self):
        self.statement.append('\n' + self.indent)
        return self

    def nla_s(self):
        self.add_indent()
        self.nl_s()
        return self

    def nlr_s(self):
        self.rem_indent()
        self.nl_s()
        return self

    def st_s(self, statement):
        self.statement.append(statement.get_script())
        return self

    def assign_s(self, var, value, op=LuaAssignmentOperator.SET, ftype=LuaFieldType.EXPR):
        value = strv(ftype, value)
        self.statement.append(var + ' ' + str(op.value) + ' ' + value)
        return self

    def binary_s(self, var, value, op, ftype=LuaFieldType.EXPR):
        value = strv(ftype, value)
        self.statement.append(var + ' ' + str(op.value) + ' ' + value)
        return self

    def logical_s(self, op):
        self.statement.append(' ' + str(op.value) + ' ')
        return self

    def unary_s(self, var, op):
        self.statement.append(str(op.value) + '' + var)
        return self

    def logical_s(self, var, op):
        self.statement.append(str(op.value) + '' + var)
        return self

    def ob_s(self):
        self.statement.append('(')
        self.brackets_count += 1
        return self

    def cb_s(self):
        self.statement.append(')')
        self.brackets_count -= 1
        return self

    def if_s(self):
        self.statement.append('if ')
        self.opened_if += 1
        return self

    def then_s(self):
        self.statement.append(' then')
        return self

    def elseif_s(self):
        self.statement.append('elseif ')
        return self

    def else_s(self):
        self.statement.append('else')
        return self

    def end_s(self):
        self.statement.append('end')
        self.opened_if -= 1
        return self
