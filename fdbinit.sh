#!/bin/bash

set -e

fdbcli --exec "configure new single ssd" || echo "Looks like FoundationDB is already configured."

bootstrap_script_tpl='
writemode on;
set "\x02m\x00\x02clusters\x00\x02local\x00" "{\"primary\":{\"region\":\"local\",\"config\":\"__FDB_CONFIG__\"},\"replicas\":[]}";
set "\x02m\x00\x02stores\x00\x02b\x00\x02info\x00" "{\"cluster\":\"local\",\"subspace\":\"b\"}";
set "\x02m\x00\x02stores\x00\x02b\x00\x02role-grants\x00" "{\"roles\":[\"service\"]}";
set "\x02m\x00\x02users\x00\x02__USER_PUBKEY__\x00\x02roles\x00" "{\"roles\":[\"service\"]}";
'

bootstrap_script=$(echo "$bootstrap_script_tpl" \
  | sed s/__FDB_CONFIG__/"$(cat /data/fdb.cluster)"/g \
  | sed s/__USER_PUBKEY__/"$(cat /mds_key.pub)"/g \
  | tr -d '\n')

fdbcli --exec "$bootstrap_script"
