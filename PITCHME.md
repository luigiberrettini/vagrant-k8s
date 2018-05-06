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

---

## Docker basics

@div[left-40]
<br />

**Image**
<br />
<small>
  <ul>
    <li>A set of read-only layers</li>
    <li>A layer is a modification to the filesystem</li>
    <li>On `docker build` a layer is created for each `Dockerfile` statement</li>
  </ul>
</small>

<br /><br />

**Container**
<br />
<small>
  <ul>
    <li>A runnable instance of an image</li>
    <li>Each `docker run` creates a writable layer on top of the image read-only ones</li>
  </ul>
</small>
@divend

@div[right-50]
<br />
![Docker Image and containers](assets/img/03-docker-image-containers.png)
@divend