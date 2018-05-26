---

# Kubernetes primer
[@fa[twitter] @luigiberrettini](http://twitter.com/luigiberrettini)

---

# Introduction

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
    @div
        **Image**
        <br />
        <small>
        <ul>
            <li>A set of read-only layers</li>
            <li>A layer is a modification to the filesystem</li>
            <li>On `docker build` a layer is created for each `Dockerfile` statement</li>
        </ul>
        </small>
    @divend
    
    @div
        <p></p>
        **Registry**
        <br />
        <small>A repository of images</small>
    @divend
    
    @div
        **Container**
        <br />
        <small>
        <ul>
            <li>A runnable instance of an image</li>
            <li>Each `docker run` creates a writable layer on top of the image read-only ones</li>
        </ul>
        </small>
    @divend
@divend

@div[right-50]
<br />
![Docker Image and containers](assets/img/03-docker-image-containers.png)
@divend

---

## Docker container demo
<br />
<br />
```shell
docker container run -d -p 8080:8080 --name dkr-demo luksa/kubia:v1

docker container logs dkr-demo

docker container exec -ti dkr-demo ls -Al

docker container stop dkr-demo
```

---

## Container orchestration
<br />
Provides features missing in Docker:
 - deploy of application stacks
 - health checking and self-healing
 - containers HA (active-active or active-passive)
 - scaling (static or dynamic)
 - groups/users and resource scoping
 - multi-tenancy
 - clustering and optimal hardware utilization

---

## Orchestrators
<br />
<br />
 - Swarm
 - Mesos (general purpose cluster manager)
 - vanilla Kubernetes
 - Kubernetes distribution (e.g. OpenShift, Tectonic)

---

# Kubernetes overview