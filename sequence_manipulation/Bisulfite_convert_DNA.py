#!/usr/bin/env python3
# This script is for generating DNA sequence to what is expected after bisulfite conversion assuming all CpGs are methylated.
greeting_message = "Please provide the fasta file for the bisulfite conversion : "
filename = input(greeting_message)
output_filename = input('please provide output fasta file name: ')
f = open(filename, "r")
f_out = open(output_filename, 'w')
first_line = f.readline()
if first_line[0] == '>':
    print('input fasta file is valid')
    f_out.write(first_line)
else:
    print("please recheck input file format, the first line won't be converted by default. ")
lines = f.readlines()
seq = ""
for line in lines:
    clean_line  = line.rstrip()
    seq += clean_line
new_seq = ''
for i in range(len(seq)-1):
    if seq[i] != "C":
        new_seq = new_seq + seq[i]
    elif seq[i+1] == "G":
        new_seq = new_seq + "C"
    else:
        new_seq = new_seq + "T"
if seq[-1] == "C":
    print("Warning! The last base is a C, it won't be included in the output!")
else:
    new_seq = new_seq + seq[-1]
while len(new_seq) > 0:
    f_out.write(new_seq[:50] + '\n')
    new_seq = new_seq[50:]
f_out.close()
f.close()
