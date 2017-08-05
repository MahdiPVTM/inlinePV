tmux kill-session -t "InlinePVCli"
tmux kill-session -t "InlinePVApi"

tmux new-session -d -s "InlinePVCli" "./cli.sh"
tmux detach -s "InlinePVCli"
echo "InlinePV now Running!"
echo "Waiting 5 sec for runing InlinePV api!"
sleep 5
tmux new-session -d -s "InlinePVApi" "./api.sh"
tmux detach -s "InlinePVApi"
echo "InlinePVApi now Running!"
