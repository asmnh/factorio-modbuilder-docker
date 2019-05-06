import os, sys, json

mod_name = os.environ.get('MOD_NAME')
mod_version = os.environ.get('MOD_VERSION')
basepath = '/code'

def clearstring(s):
    return s.replace('\r', '').replace('\n', '').strip()

def from_file(fname, default=None, force=False):
    try:
        with open(os.path.join(basepath, fname), 'rt') as f:
            return clearstring(f.read())
    except FileNotFoundError:
        if force:
            raise
        return default

base_info = {}
try:
    base_info = json.loads(from_file('info_template.json', force=True))
except Exception:
    base_info = {}

def getval(key, default=None, force=False, env_prefix='MOD_', filename=None):
    val = os.environ.get(env_prefix + key)
    if val: return val
    if key in base_info:
        return base_info[key]
    else:
        return from_file(filename or key, default, force)

factorio_version = getval('FACTORIO_VERSION', force=True)

print(f'Building infofile for {mod_name}:{mod_version}')
def load_dependencies():
    def yield_dependencies():
        with open(os.path.join(basepath, 'dependencies.txt'), 'rt') as f:
            yield f
    try:
        return [clearstring(dep) for dep in yield_dependencies()]
    except FileNotFoundError:
        # no dependencies, just add dependency to game version
        return [f'base >= {factorio_version}']

info = {
    'name': mod_name,
    'version': mod_version,
    'title': getval('TITLE', default=mod_name),
    'author': getval('AUTHOR', force=True),
    'contact': getval('CONTACT_INFO', ''),
    'homepage': getval('HOMEPAGE', ''),
    'factorio_version': factorio_version,
    'dependencies': load_dependencies(),
    'description': getval('DESCRPIPTION', filename='description.txt', default='')
}

with open('tmp/info.json', 'wt') as output:
    output.write(json.dumps(info))

