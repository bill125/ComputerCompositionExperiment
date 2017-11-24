with open('./instruction.csv') as fin:
    constants = ''
    insts = {}
    for i in fin.readlines()[1:]:
        i = i.split(',')
        inst_name = i[0].replace('*', '')
        op = i[2][:5]
        funct = i[3]
        inst = i[2]
        constant_stmt = '    constant OP_{inst_name}: std_logic_vector(4 downto 0) := "{op}";\n'.format(inst_name=inst_name, op=op)
        constants += constant_stmt
        if inst_name == 'NOP':
            constants += '    constant INST_{inst_name}: std_logic_vector(15 downto 0) := "{inst}";\n'.format(inst_name=inst_name, inst=inst)

    res = '''library IEEE;
use work.constants.op_t;
use IEEE.std_logic_1164.all;

package inst_const is
{constants}
end;'''.format(constants=constants, funchead=funchead, funcbody=funcbody)
    print(res)
