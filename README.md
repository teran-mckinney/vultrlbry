#vultrlbry
###libry nodes on vultr

Creates a 4GiB libry instance in the specified region.

Active on IPv4 and IPv6.

# Prerequisites

Needs Golang installed. Also set a GOPATH, like:

```
$ mkdir $HOME/golang
$ export GOPATH=$HOME/golang
```

# Steps

1. Create account on http://vultr.com
2. Go under settings and enable the API
3. `git clone` this repo and `cd` into it.
4. `$ export VULTR_API_KEY=(APIKEY)`
5. `$ go get github.com/JamesClonk/vultr`
6. `$ vultr regions` (Note the region number you want)
7. `$ ./deploy (region number)`

# License

Public domain / Unlicense

TODO:

Make startup script checksummed.
