import sys,re

if __name__=="__main__":
    #allvers = sorted(set(sys.stdin))
    allvers = sys.stdin
    early = []
    late = []
    standard = []
    for version in allvers:
        if re.match("v[0-9]+r[0-9p]+",version):
            standard.append(version)
        elif version in ['HEAD\n','prod\n']:
            early.append(version)
        else:
            late.append(version)
    # FIXME natsort not available in python 2 on lxplus
    #from natsort import natsort
    #natsort(standard)
    #standard.reverse()
    for version in early:
        sys.stdout.write(version)
    for version in standard:
        sys.stdout.write(version)
    for version in late:
        sys.stdout.write(version)
