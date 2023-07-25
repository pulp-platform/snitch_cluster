# -----------------------------
# Copyright 2023 Katolieke Universiteit Leuven (KUL)
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
# Author: Ryan Antonio (ryan.antonio@kuleuven.be)
# -----------------------------

# Manual assembler for basic operations only
import sys

def ext_type(value,mode = 'reg'):

  # Dumb way is just to zero pad long
  # Then just get the lower 12 bits for imm extension
  # Get lower 5 bits for reg extension

  zero_padd   = '0000000000000000'
  zero_padded = zero_padd + str(format(int(value),'b'))

  if mode == 'reg':
    return zero_padded[-5:]
  else:
    return zero_padded[-12:]

def hex_fix(m_inst):
  machine_int  = int(m_inst,2)
  hex_nopad    = hex(machine_int)[2:]
  hex_zero_pad = '00000000' + hex_nopad
  hex_code     = hex_zero_pad[-8:]
  return hex_code


def decode(entry):

  hex_code = ''
  
  if(entry[0] == 'addi'):
    imm          = ext_type(entry[3],'imm')
    rs1          = ext_type(int(entry[2].strip('x').strip(',')),'reg')
    f3           = '000'
    rd           = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    op           = '0010011'
    machine_inst = imm+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif (entry[0] == 'add'):
    pass
  elif (entry[0] == 'lw'):
    imm          = ext_type(int(entry[2].split('(')[0].strip('#')),'imm')
    rs1          = ext_type(int(entry[2].split('(')[1].strip('x').strip(')')),'reg')
    f3           = '010'
    rd           = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    op           = '0000011'
    machine_inst = imm+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'sw'):
    imm_tmp      = ext_type(int(entry[2].split('(')[0].strip('#')),'imm')
    imm_11_5     = imm_tmp[0:7]
    imm_4_0      = imm_tmp[7:12]
    rs1          = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    f3           = '010'
    rs2          = ext_type(int(entry[2].split('(')[1].strip('x').strip(')')),'reg')
    op           = '0100011'
    machine_inst = imm_11_5 + rs2 + rs1 + f3 + imm_4_0 + op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'dmsrc'):
    f7           = '0000000'
    rs2          = ext_type(int(entry[2].strip('x').strip(',')),'reg')
    rs1          = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    f3           = '000'
    rd           = '00000'
    op           = '0101011'
    machine_inst = f7+rs2+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'dmdst'):
    f7           = '0000001'
    rs2          = ext_type(int(entry[2].strip('x').strip(',')),'reg')
    rs1          = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    f3           = '000'
    rd           = '00000'
    op           = '0101011'
    machine_inst = f7+rs2+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'dmcpy'):
    f7           = '0000011'
    rs2          = ext_type(int(entry[3].strip('x').strip(',')),'reg')
    rs1          = ext_type(int(entry[2].strip('x').strip(',')),'reg')
    f3           = '000'
    rd           = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    op           = '0101011'
    machine_inst = f7+rs2+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'dmstat'):
    f7           = '0000101'
    rs2          = ext_type(int(entry[2].strip('x').strip(',')),'reg')
    rs1          = '00000'
    f3           = '000'
    rd           = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    op           = '0101011'
    machine_inst = f7+rs2+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'dmrep'):
    f7           = '0000111'
    rs2          = '00000'
    rs1          = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    f3           = '000'
    rd           = '00000'
    op           = '0101011'
    machine_inst = f7+rs2+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == 'dmstr'):
    f7           = '0000110'
    rs2          = ext_type(int(entry[2].strip('x').strip(',')),'reg')
    rs1          = ext_type(int(entry[1].strip('x').strip(',')),'reg')
    f3           = '000'
    rd           = '00000'
    op           = '0101011'
    machine_inst = f7+rs2+rs1+f3+rd+op
    hex_code     = hex_fix(machine_inst)
  elif(entry[0] == '#'):
    pass
  else:
    # This is nop
    hex_code = '00000013'

  return hex_code


if __name__ == '__main__':

  target_name = sys.argv[1]

  print(target_name)

  asm_dir   = "./asm/"
  inst_dir  = "./inst/"
  
  asm_file  = asm_dir  + target_name + ".s"
  inst_file = inst_dir + target_name + ".txt"

  inst_list = []

  with open(asm_file,"r") as inst_asm:
    for inst_code in inst_asm:
      entry = inst_code.strip().split()
      print(decode(entry))
      inst_list.append(decode(entry))

  with open(inst_file,"w") as inst_mem:
    for inst in inst_list:
      inst_mem.write(inst + "\n")


