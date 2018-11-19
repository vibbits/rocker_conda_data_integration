import sys
import pandas as pd


def processMainFile(mainInputFile):
    '''
    Read a tab delimited text file with a header line and 5 columns:
    BINCODE NAME    IDENTIFIER      DESCRIPTION     TYPE

    Get a unique list of bincodes and gene identifiers. 
    For each bincode, output a comma separated row of ones and zeros for all gene ids
    depending on whether the given gene is annotated with given bincode.
    '''
    
    ## Read the tab delimited input file into a pandas dataframe
    df = pd.read_table(mainInputFile)

    ## Extract an ordered unique list of BINCODEs
    bincodes = sorted(df['BINCODE'].unique())

    ## Extract a unique array of gene_ids (column 'IDENTIFIER')
    gene_ids = df['IDENTIFIER'].unique()
    ## Filter away the empty NaN/null value (some lines don't have a gene id)
    gene_ids = gene_ids[~pd.isnull(gene_ids)]
    ## Sort the result into a list
    gene_ids = sorted(gene_ids)

    ## Create and print the matrix header (one empty spot at the start)
    output_header = [''] + gene_ids
    print(','.join(output_header))

    ## Iterate all unique BINCODES
    for bc in bincodes:
        ## Find a list in the dataframe of all genes with given bincode
        genesWithBC = list(df[df.BINCODE == bc]['IDENTIFIER'].unique())
        ## use list comprehension to create a list with '0' and '1'
        ## for every gene in the unique gene_ids list.
        ## Prepend the list with the current bincode
        row = [bc] + ['1' if gene in genesWithBC else '0' for gene in gene_ids]
        print(','.join(row))

    
    
if __name__ == '__main__':
    processMainFile(sys.argv[1])
