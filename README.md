# BAMClipper v 1.0

## What does this app do?
This app applies [BAMClipper](https://github.com/tommyau/bamclipper) to softclip primer sequences from aligned data. BAMClipper utilises a BEDPE file describing the genomic coordinates of the primers and alters the CIGAR string to remove the primer sequences from either end of the template.

## What are typical use cases for this app?
Softclipping primer sequences prevents primer sequences from being included in variant calling. This is particularly relevant where the panel design includes tiled amplicons. If a variant falls within a primer sequence that template may not be amplified, resulting in the allele frequency being underestimated. 

Soft clipping primers after alignment helps ensure reads are mapped accurately and are more tolerant of variants near the edge of the region of interest. 

This app is used for amplicon based panels.

## What data are required for this app to run?
* Aligned reads (BAM file)
* BEDPE detailing the primer coordinates.
* Upstream (optional) - Each read must be assigned to a amplicon as defined by the 5' primer start coordinate. These parameters allow this window to be extended upstream so reads can be assigned to this amplicon. If not given BAMclipper defaults to 1 (by default the app does not provide a value).
* Downstream (optional) - as above per upstream extend the window to assigned reads to a amplicon. If not given BAMclipper defaults to 5 (by default the app does not provide a value).


The BEDPE file has the following required fields:
> chr1   start1   stop1    chr2    start2   stop2

(additonal optional fields such as name can be added - see [here](https://bedtools.readthedocs.io/en/latest/content/general-usage.html#bedpe-format).

As with all BED files, start positions are zero based, end position are one based.


## What does this app output?
* Clipped BAM file (*primerclipped.bam) and associated index (*primerclipped.bam.bai)

## How does this app work?
* Installs GNU parallel from apt-get (specifying required version)
* Builds the BAMClipper arguments including inputs described above and the path to SAMtools (packaged up in the app).
* Execute packaged instance of BAMClipper (v1.1.1) using above arguments

## Custom modifications
* The app was made by Viapath Genome Informatics
