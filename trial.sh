set -x
vagrant ssh grant-k8s-node0 -- -t '/opt/pwx/bin/pxctl license trial; exit'
vagrant ssh grant-k8s-node1 -- -t '/opt/pwx/bin/pxctl license trial; exit'
vagrant ssh grant-k8s-node2 -- -t '/opt/pwx/bin/pxctl license trial; exit'
