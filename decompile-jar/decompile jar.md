# Decompile jar

## Prerequisites

Download <http://www.benf.org/other/cfr/>


## Commands

Decompile one file

```
java -jar cfr-0.152.jar archive.jar --outputdir tmp
```

Decompile all jar files in current folder

```
dir -recurse -include *.jar | Resolve-Path -Relative | %{java -jar cfr-0.152.jar $_  --outputdir out\$_}

java -jar cfr-0.152.jar rpgboard-1.0.0-SNAPSHOT-fat.jar --outputdir tmp
```
