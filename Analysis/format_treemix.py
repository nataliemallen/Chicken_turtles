import pandas as pd

sites = ['warren', 'buller', 'gordy', 'alazan', 'wharton']
output_file = "treemix_input.gz"

# Load all frequency files
freq_dfs = {site: pd.read_csv(f"{site}_freqs.mafs", sep="\t") for site in sites}

# Check that SNP positions match
positions = freq_dfs[sites[0]][['chromo', 'position']]
for site in sites[1:]:
    positions = positions.merge(freq_dfs[site][['chromo', 'position']], on=['chromo', 'position'])

# Write the merged data
with open(output_file, 'wt') as out:
    # Write header (only site columns)
    out.write("\t".join(sites) + "\n")
    
    for _, pos in positions.iterrows():
        counts = []
        
        for site in sites:
            row = freq_dfs[site][(freq_dfs[site]['chromo'] == pos['chromo']) & (freq_dfs[site]['position'] == pos['position'])].iloc[0]
            ref_count = row['knownEM'] * 2 * row['nInd']
            alt_count = (1 - row['knownEM']) * 2 * row['nInd']
            counts.append(f"{int(ref_count)},{int(alt_count)}")
        
        # Write the counts for each site, no SNP column
        out.write("\t".join(counts) + "\n")
