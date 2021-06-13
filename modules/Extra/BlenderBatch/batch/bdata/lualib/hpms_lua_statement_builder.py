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
        self.statement = LuaStatement('-- TODO')
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
        pass

    def build(self):
        self.validate()
        return self.statement

    def reset(self):
        self.statement = ''
        return self

    def nl_s(self):
        self.statement += '\n'
        return self

    def assign_s(self, var, value, ftype=LuaFieldType.STRING, op=LuaAssignmentOperator.SET):
        value = strv(ftype, value)
        self.statement.content += var + ' ' + str(op) + ' ' + value
        return self

    def binary_s(self, var, value, ftype=LuaFieldType.STRING, op=LuaBinaryOperator):
        value = strv(ftype, value)
        self.statement.content += var + ' ' + str(op) + ' ' + value
        return self

    def logical_s(self, op=LuaLogicalOperator):
        self.statement.content += ' ' + str(op) + ' '
        return self

    def unary_s(self, var, op=LuaUnaryOperator):
        self.statement.content += str(op) + '' + var
        return self

    def logical_s(self, var, op=LuaUnaryOperator):
        self.statement.content += str(op) + '' + var
        return self

    def ob_s(self):
        self.statement.content += '('
        self.brackets_count += 1
        return self

    def cb_s(self):
        self.statement.content += ')'
        self.brackets_count -= 1
        return self

    def if_s(self):
        self.statement.content += 'if '
        self.opened_if += 1
        return self

    def then_s(self):
        self.statement.content += 'then'
        self.nl_s()
        return self

    def elseif_s(self):
        self.rem_indent()
        self.statement.content = 'elseif '
        return self

    def else_s(self):
        self.rem_indent()
        self.statement.content = 'else'
        self.add_indent()
        self.nl_s()
        return self

    def end_s(self):
        self.rem_indent()
        self.statement.content = 'end'
        self.nl_s()
        self.opened_if -= 1
        return self
