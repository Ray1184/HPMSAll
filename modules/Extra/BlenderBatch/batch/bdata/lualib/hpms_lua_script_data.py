"""
HPMS Lua script representation.

"""

from abc import ABCMeta, abstractmethod
from enum import Enum
import datetime

INDENT = '    '


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

    def get_script(self):
        return self.content


class LuaUserCode(IScriptSection):

    def __init__(self, content=None):
        self.content = content

    def get_script(self):
        user_content = '-- USER SECTION START\n'
        if self.content:
            user_content += self.content
        else:
            user_content += '\n-- Write here additional code...\n'
        user_content += '\n-- USER SECTION END'
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
            self.user_section = LuaUserCode()
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
    BOOL = 1
    STRING = 2
    INT = 3
    DECIMAL = 4
    OBJECT = 5


class LuaField(IScriptSection):

    def __init__(self, name, value='Template', ftype=LuaFieldType.STRING):
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

    def add_callback(self, callback):
        self.callbacks.append(callback)


class LuaScript(IScriptSection):

    def __init__(self, name='Template'):
        self.name = name
        self.sections = []

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

