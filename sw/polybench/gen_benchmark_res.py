import os

def get_filename(target):
    if(target == 'cov'):
        filename  = "covariance"
    elif(target == 'corr'):
        filename = "correlation"
    elif(target == 'atax'):
        filename = "atax"
    
    return filename

def gen_makefile(target):
    with f as open("Makefile", "w"):
        f.write(f"APP = polybench_{target}\nSRCS = runnable.c\nINCDIRS = data\n\ninclude ../common.mk")

targets = ['atan', 'corr', ' cov']
prob_sz = [8, 16, 20]
paral   = ['single', 'omp']

for sz in prob_sz:
    os.system(f"./runall.sh {sz}")
    for tg in targets:
        gen_makefile(tg)
        for pr in paral:
            