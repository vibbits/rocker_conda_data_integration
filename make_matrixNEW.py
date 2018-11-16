#!/usr/bin/env python3
import pandas as pd
import numpy as np
import sys
import click

def loadData(geneFileName, goFileName):
    '''
    Load both csv files in a pandas dataframe
    '''
    medicagoGOpd = pd.read_csv(geneFileName)
    goUniq = pd.read_csv(goFileName)
    return (medicagoGOpd, goUniq)

def writeMatrix(genes, gos, use_description=False):
    '''
    Iterate the gos and print corresponding matrix rows to stdout.
    '''
    uniqueGenes = list(set(genes['gene_id']))
    header = [''] + uniqueGenes
    print(','.join(header))

    for go in gos['go']:
        desc = genes[genes.go == go]['desc'].values[0]
        if use_description:
            row = [desc]
        else:
            row = [go]
        genesWithGo = list(genes[genes.go == go]['gene_id'])
        for geneId in uniqueGenes:
            row.append('1' if geneId in genesWithGo else '0')
        print(','.join(row))


@click.command()
@click.argument('gene_file',
                type=click.Path(exists=True)
)
@click.argument('go_file',
                type=click.Path(exists=True)
)
@click.option('--description', '-d', 'use_description',
              is_flag=True,
              default=False,
              help='Use GO description instead of GO ID')
def main(gene_file, go_file, use_description):
    '''
    Load two CSV files into memory, iterate all GO ids of the GOs.csv file,
    look up the genes that have this GO id and print a row to stdout with 0's and 1's indicating
    which genes are in the GO category.

    GENE_FILE: comma separated with header: gene_id,go,desc

    GO_FILE: single colum with header: go
    '''
    (medicagoGOpd, goUniq) = loadData(gene_file, go_file)
    writeMatrix(medicagoGOpd, goUniq, use_description)


if __name__ == '__main__':
    main()
