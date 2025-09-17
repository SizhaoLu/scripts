#!/usr/bin/env python3
# This script is for generating suitable input for CellAssign using a table
# with a cell type and correponding gene in each line
def get_genelist_file(filename):
    with open(filename) as genelist_file:
        genelist = [line.rstrip() for line in genelist_file]
        non_redundant_genelist = list(set(genelist))
    return non_redundant_genelist
greeting_message = "Please provide the file name for the gene signature file:  "
filename = input(greeting_message)
try:
    f = open(filename, "r")
except:
    print("file is not found, please check your file name/path.")
# first create a dict where the keys correspond to cell types while the list contained has marker genes
gene_list = []
marker_dict = {}
for x in f:
    line_list = x.split("\t")
    gene_list.append(line_list[1].rstrip())
    if line_list[0] in marker_dict.keys():
        marker_dict[line_list[0]].append(line_list[1].rstrip())
    else:
        marker_dict[line_list[0]] = [line_list[1].rstrip()]
gene_list_uniq = list(set(gene_list))
f.close()
save_message = "Please provide the file name for saving the generated file:  "
target_file_name = input(save_message)
target_file = open(target_file_name, "w")
first_line = 'Gene,' + ','.join(marker_dict.keys()) + '\n'
target_file.write(first_line)
for gene in gene_list_uniq:
    line_list = []
    for cell in marker_dict.keys():
        if gene in marker_dict[cell]:
            line_list.append('1')
        else:
            line_list.append('0')
    line = gene + ',' + ','.join(line_list) + '\n'
    target_file.write(line)
target_file.close()
