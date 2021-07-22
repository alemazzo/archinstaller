from yaml import load, dump
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper


def loadYamlFromFile(path: str):
    stream = open(path)
    data = load(stream, Loader=Loader)
    return data
