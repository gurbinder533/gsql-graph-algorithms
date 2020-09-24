# Print number of nodes
curl -X POST 'http://localhost:9000/builtins/datagen75' -d  '{"function":"stat_vertex_number","type":"*"}'  | jq .
# Print number of edges
curl -X POST 'http://localhost:9000/builtins/datagen75' -d  '{"function":"stat_edge_number","type":"*"}' | jq .
GSQL> set query_timeout=90000

### SET timeout default:
gadmin config entry RESTPP.Factory.DefaultQueryTimeoutSec
gadmin config apply
gadmin restart

## LOAD graph
gsql datagen75-setup.gsql
nohup  gsql -g datagen75 'run loading job load_datagen75_edge using file1="/home/ubuntu/data/ldbc_graphalytics/datagen-7_5-fb/datagen-7_5-fb.e"'

## RUNNING
time gsql -g datagen75 'run query shortest_ss_no_wt((6, "Node"), (2199023394910, "Node"), false)'
time gsql -g datagen81 'run query pageRank(0.000001,10,0.85, false, 10, (6, "Node"))'
