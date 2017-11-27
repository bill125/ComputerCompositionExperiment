import re
import os
import argparse

def indent(s):
    res = ''
    for i in s.split('\n'):
        res += '    ' + i + '\n'
    return res

file_list = ['PC', 'IM', 'IF_ID', 'Register', 'ImmExtend', 'Control','Decoder', 'ForwardUnit', 'JumpAndBranch', 'ID_EX', 'ALU_MUX', 'ALU', 'EX_MEM', 'DM', 'MEM_WB', 'StallClearController', 'BTB']

#file_list = ['SystemBusController', 'ExtBusController', 'UART']

parser = argparse.ArgumentParser()
parser.add_argument('--input_dir', type=str, required=True)
parser.add_argument('--output', type=str, required=True)
args = parser.parse_args()
regex = re.compile(r'entity\s*(\S*).*?end\s*?\S*?;', flags=re.DOTALL|re.IGNORECASE)
regex_sub = re.compile(r'entity')
#regex_in = re.compile(r'\S*?\s*?:\s*?in\s*?;)
res = ''
out_signals = []
port_maps = []
components = []
for file_name in file_list:
    signal_names = []
    file_name = os.path.join(args.input_dir, file_name + '.vhd')
    print('processing', file_name)
    assert(os.path.exists(file_name))
    src = open(file_name, 'r').read()
    search_res = regex.search(src)
    entity = search_res.group()
    name = search_res.group(1)
    port_map = name + '_inst: {name} port map (\n'.format(name=name)
    component = re.sub(r'entity(\s*?\S*?\s*?)is(.*)end.*', r'component\1\2end component;', entity, flags=re.DOTALL|re.IGNORECASE)
    components.append(component)
    
    st = 0
    ed = 0
    for i in range(len(component)):
        if component[i] == '(':
            st = i
            break
    st += 1
    for j in range(len(component) - 1, -1, -1):
        if component[j] == ')':
            ed = j
            break
    signals = component[st:ed].split('\n')
    for signal in signals:
        signal = signal.strip()
        if len(signal) == 0: continue
        signal_name = signal[:signal.find(':')].strip()
        signal_names.append(signal_name)
        port_map += '    ' + signal_name + ' => '
        if re.search(':\s*out', signal, flags=re.IGNORECASE) is not None:
            if signal[-1] != ';':
                signal += ';'
            signal = name + '_' + signal
            port_map += name + '_' + signal_name
            out_signals.append('signal ' + re.sub(r':\s*out', ':', signal, flags=re.IGNORECASE))
        port_map += ',\n'
    port_map = port_map[:-2] + '\n);'
    print('port_map=')
    print(port_map)
    port_maps.append(port_map)
    print('-------------------------------')


res = '''ARCHITECTURE behavior OF <name> IS
{components}
{out_signals}
begin
{port_maps}
end;'''.format(components=indent('\n'.join(components)),
               out_signals=indent('\n'.join(out_signals)),
               port_maps=indent('\n'.join(port_maps)))

open(args.output, 'w').write(res)
