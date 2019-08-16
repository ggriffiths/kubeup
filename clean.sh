set -x
vagrant ssh grant-k8s-node0 -- -t 'sudo systemctl stop portworx; sudo /opt/pwx/bin/pxctl sv nw --all; exit'
vagrant ssh grant-k8s-node1 -- -t 'sudo systemctl stop portworx; sudo /opt/pwx/bin/pxctl sv nw --all; exit'
vagrant ssh grant-k8s-node2 -- -t 'sudo systemctl stop portworx; sudo /opt/pwx/bin/pxctl sv nw --all; exit'
