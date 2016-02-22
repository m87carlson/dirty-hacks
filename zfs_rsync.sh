#!/usr/bin/env bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin
usage()
{
cat << EOF
 
        Usage: $0 /zpool/filesystem 90d
 
        This script will send list of files using find and rsync over
	N days
 
EOF
}

if [[ -z $1 || -z $2 ]]
then
	usage
	exit 1
fi
 
pool=$1
retention_period=$2
remote_pool=`echo $1 |awk -F/ '{print $NF}'`
destination="/data/`hostname -s`-backup/$remote_pool"
host="zfs-3"

echo "DEBUG:"
echo "pool=${pool}"
echo "remote_pool=${remote_pool}"
echo "destination=${destination}"
echo "host=${host}"

cd $pool
find . -type f -mtime -${retention_period} -print0 | rsync -av --progress -t --files-from=- --from0 ./ ${host}:${destination}
