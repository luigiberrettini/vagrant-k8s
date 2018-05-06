---

# Kubernetes intro
[@fa[twitter] @luigiberrettini](http://twitter.com/luigiberrettini)

---

# Overview

---

## VMs vs containers

@div[left-50]
<br /><br />
![Virtual machines](assets/img/01-virtual-machines.png)
@divend

@div[right-50]
<br /><br />
![Containers](assets/img/02-containers.png)
@divend

---

## Process isolation

**Resource usage** is limited with **cgroups** (control groups)
<br />
<br />
**Resource access** is limited with **namespaces** i.e. a process belongs to a namespace for each type:
 - ipc
 - mnt
 - net
 - pid
 - user
 - uts (UNIX Timesharing System)