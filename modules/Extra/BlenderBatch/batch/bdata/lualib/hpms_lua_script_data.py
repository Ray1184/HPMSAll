"""
HPMS Lua script representation.

"""

from abc import ABCMeta, abstractmethod
from enum import Enum
import datetime

INDENT = '    '
USER_SECTION_START = '-- CUSTOM CODE STARTS HERE, DO NOT REMOVE THIS LINE'
USER_SECTION_END = '-- CUSTOM CODE STOPS HERE, DO NOT REMOVE THIS LINE'


class IScriptSection:
    __metaclass__ = ABCMeta

    @abstractmethod
    def get_script(self):
        raise NotImplementedError


class LuaStatement(IScriptSection):

    def __init__(self, content, plain_string=False, add_comma=False):
        self.add_comma = add_comma
        if plain_string:
            self.content = '\'' + content + '\''
        else:
            self.content = content

    def append(self, val):
        self.content += str(val)

    def get_script(self):
        return self.content


class LuaUserCode(IScriptSection):

    def __init__(self, content=None, callback_name='dummy'):
        self.content = content
        self.callback_name = callback_name

    def get_script(self):
        user_content = USER_SECTION_START + ' [' + self.callback_name + ']\n'
        user_content += self.content
        user_content += '\n' + USER_SECTION_END + ' [' + self.callback_name + ']'
        return user_content


class LuaCallback(IScriptSection):

    def __init__(self, name, params=None):
        if params is None:
            params = []
        self.name = name
        self.params = params
        self.statements_pre = []
        self.user_section = None
        self.statements_post = []

    def get_script(self):
        param_desc = ''
        if self.params:
            param_desc = ', '
            param_desc = param_desc.join(self.params)
        fun_body = self.name + ' = function(' + param_desc + ')'
        for stat in self.statements_pre:
            for line in stat.get_script().splitlines():
                fun_body += '\n' + INDENT + line
        if self.user_section is None:
            self.user_section = LuaUserCode('-- TODO', self.name)
        else:
            self.user_section.callback_name = self.name
        for line in self.user_section.get_script().splitlines():
            fun_body += '\n' + INDENT + line
        for stat in self.statements_post:
            for line in stat.get_script().splitlines():
                fun_body += '\n' + INDENT + line
        fun_body += '\nend\n'
        return fun_body

    def add_statement_pre(self, statement):
        self.statements_pre.append(statement)

    def set_user_section(self, section):
        self.user_section = section

    def add_statement_post(self, statement):
        self.statements_post.append(statement)


class LuaFieldType(Enum):
    EXPR = 0
    BOOL = 1
    STRING = 2
    INT = 3
    DECIMAL = 4
    VAR = 5


class LuaField(IScriptSection):

    def __init__(self, name, value='Template', ftype=LuaFieldType.EXPR):
        self.name = name
        self.ftype = ftype
        self.value = value

    def get_script(self):
        formatted_value = self.value
        if self.ftype == LuaFieldType.STRING:
            formatted_value = '\'' + self.value + '\''
        return self.name + ' = ' + formatted_value


class LuaMacroSection(IScriptSection):

    def __init__(self, name):
        self.name = name
        self.statements = []
        self.fields = []
        self.callbacks = []
        self.fields_dict = {}
        self.callbacks_dict = {}

    def get_script(self):
        script_data = '\n' + self.name + ' = {'
        count = 0
        token = ''
        for stat in self.statements:
            if count > 0:
                token = ','
            script_data += token
            for line in stat.get_script().splitlines():
                script_data += '\n' + INDENT + line
            count += 1
        for field in self.fields:
            if count > 0:
                token = ','
            script_data += token
            for line in field.get_script().splitlines():
                script_data += '\n' + INDENT + line
            count += 1
        for callback in self.callbacks:
            if count > 0:
                token = ','
            script_data += token
            for line in callback.get_script().splitlines():
                script_data += '\n' + INDENT + line
            count += 1
        script_data += '\n}'
        return script_data

    def add_statement(self, statement):
        self.statements.append(statement)

    def add_field(self, field):
        self.fields.append(field)
        self.fields_dict[field.name] = field

    def add_callback(self, callback):
        self.callbacks.append(callback)
        self.callbacks_dict[callback.name] = callback

    def get_field(self, field_name):
        return self.fields_dict[field_name]

    def get_callback(self, callback_name):
        return self.callbacks_dict[callback_name]


class LuaScript(IScriptSection):

    def __init__(self, name='Template'):
        self.name = name
        self.sections = []
        self.sections_dict = {}

    def get_script(self):
        date = datetime.datetime.now().strftime("%d-%m-%Y")
        script_data = '-- ' + self.name
        script_data += '\n-- Generated with Blend2HPMS batch on date ' + date
        for section in self.sections:
            for line in section.get_script().splitlines():
                script_data += '\n' + line
        return script_data

    def add_section(self, section):
        self.sections.append(section)
        self.sections_dict[section.name] = section

    def get_section(self, section_name):
        return self.sections_dict[section_name]
