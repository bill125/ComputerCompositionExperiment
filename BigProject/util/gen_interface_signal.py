s = open('./tmp.txt').read().strip().split()
body = ''
new_s = []
for i in s:
    _, name = i.split('_')
    if i.find('/') != -1:
        new_s.append('i_' + name)
        new_s.append('o_' + name)
    else:
        new_s.append(i)
new_s = sorted(new_s)
for i in new_s:
    io_type, _ = i.split('_')
    if io_type == 'i':
        io_type = 'in'
    elif io_type == 'o':
        io_type = 'out'
    elif io_type == 'io':
        io_type = 'inout'
    body += '        {name} : {type} std_logic;\n'.format(name=i, type=io_type)
res = '''
    port (
'''+body[:-2]+'''
    );'''
print(res)
