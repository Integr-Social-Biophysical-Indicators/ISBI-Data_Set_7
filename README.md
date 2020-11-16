# Data Compression
##### source: https://eriqande.github.io/rep-res-eeb-2017/week5.html


### Saving Data in `CSV` Format

In general, `.csv` is a good format to store data. But when you have a long table with repatitive entries in columns (introducing redundant information) it is not the most space-efficient format. For example, one column of a very long table might contain entries that are restricted to a small set of words (such as 10 siteids, or 5 project names repeated for the whole length of the table). Each words requires few bytes, but when used in a column that has millions of rows, it can take a lot of space on a hard drive. 

**"Data compression is the art of finding ways of using short “code-names” for things or patterns that occur frequently in a file, and in so doing, reducing the overall file size".**


### Compressing Data with `gzip` 

In Linux files can be compressed using the `gzip` command. When we compress the file it gets renamed by adding a `.gz` extension on it. _Gzipped files can be read in directely by the functions of the `readr` package (such as, `read_csv()`)_. You can also unzip file using Linux command `gunzip`.

In the Terminal we can use `du` (stands for "disk usage") to see space used by a file.

```
du -h Output_Data/dn07.csv
gzip Output_Data/dn07.csv
du -h Output_Data/dn07.csv.gz
gunzip Output_Data/dn07.csv.gz

```

### Compressing Data with `xz` in `saveRDS()`
In R a table can be saved as R object using the `saveRDS()` function with the `xz` compression option. There are other compressions available with `RDS` (such as `gzip` and `bzip2`).

```
saveRDS(df, file = "Output_Data/dn07_xz.rds", compress = "xz")
readRDS(file = "Output_Data/dn07_xz.rds") 
```


