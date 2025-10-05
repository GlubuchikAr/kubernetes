# Домашнее задание к занятию «Как работает сеть в K8s»

## Цель задания

Настроить сетевую политику доступа к подам.

## Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.

[fronend.yaml](fronend.yaml)

[backend.yaml](backend.yaml)

[cache.yaml](cache.yaml)

[namespace.yaml](namespace.yaml)

4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.

[network-policies.yaml](network-policies.yaml)

5. Продемонстрировать, что трафик разрешён и запрещён.

### Запускаем приложение
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl apply -f namespace.yaml -f frontend.yaml -f backend.yaml -f cache.yaml
Warning: resource namespaces/app is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
namespace/app configured
deployment.apps/frontend created
service/frontend created
deployment.apps/backend created
service/backend created
deployment.apps/cache created
service/cache created
```

```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl get all -n app
NAME                            READY   STATUS    RESTARTS   AGE
pod/backend-c5b88c6bc-cf5b2     1/1     Running   0          24s
pod/cache-589bf5cd89-k2n5j      1/1     Running   0          24s
pod/frontend-67f4f69dcf-qrxpf   1/1     Running   0          24s

NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/backend    ClusterIP   10.152.183.139   <none>        80/TCP    24s
service/cache      ClusterIP   10.152.183.43    <none>        80/TCP    24s
service/frontend   ClusterIP   10.152.183.44    <none>        80/TCP    24s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend    1/1     1            1           24s
deployment.apps/cache      1/1     1            1           24s
deployment.apps/frontend   1/1     1            1           24s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-c5b88c6bc     1         1         1       24s
replicaset.apps/cache-589bf5cd89      1         1         1       24s
replicaset.apps/frontend-67f4f69dcf   1         1         1       24s
```

```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl get pods -n app -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE                  NOMINATED NODE   READINESS GATES
backend-c5b88c6bc-cf5b2     1/1     Running   0          22m   10.1.127.124   glubuchik-x15-at-22   <none>           <none>
cache-589bf5cd89-k2n5j      1/1     Running   0          22m   10.1.127.96    glubuchik-x15-at-22   <none>           <none>
frontend-67f4f69dcf-qrxpf   1/1     Running   0          22m   10.1.127.125   glubuchik-x15-at-22   <none>           <none>
```
### Проверяем доступность компонентов
с frontend до backend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/frontend -n app -- curl -s http://backend.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - backend-c5b88c6bc-cf5b2 - 10.1.127.124 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с frontend до cache
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/frontend -n app -- curl -s http://cache.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - cache-589bf5cd89-k2n5j - 10.1.127.96 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с backend до cache
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/backend -n app -- curl -s http://cache.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - cache-589bf5cd89-k2n5j - 10.1.127.96 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с backend до frontend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/backend -n app -- curl -s http://frontend.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - frontend-67f4f69dcf-qrxpf - 10.1.127.125 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с cache до frontend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/cache -n app -- curl -s http://frontend.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - frontend-67f4f69dcf-qrxpf - 10.1.127.125 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с cache до backend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/cache -n app -- curl -s http://backend.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - backend-c5b88c6bc-cf5b2 - 10.1.127.124 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
**Вывод:** без политик со всех сервисов есть доступ до всех остальных сервисов

### Включаем сетевые политики
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl apply -f network-policies.yaml
networkpolicy.networking.k8s.io/allow-frontend-to-backend created
networkpolicy.networking.k8s.io/allow-backend-to-cache created
networkpolicy.networking.k8s.io/deny-all-ingress created
```
Проверяем созданные политики
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl get networkpolicies -n app
NAME                        POD-SELECTOR   AGE
allow-backend-to-cache      app=cache      7s
allow-frontend-to-backend   app=backend    7s
deny-all-ingress            <none>         7s
```
Проверяем созданные политики
с frontend до backend
```bash
kubectl exec -it deployment/frontend -n app -- curl -s http://backend.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - backend-c5b88c6bc-cf5b2 - 10.1.127.124 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с frontend до cache
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/frontend -n app -- timeout 5 curl -s http://cache.app.svc.cluster.local
command terminated with exit code 143
```
с backend до cache
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/backend -n app -- timeout 5 curl -s http://cache.app.svc.cluster.local
Praqma Network MultiTool (with NGINX) - cache-589bf5cd89-k2n5j - 10.1.127.96 - HTTP: 80 , HTTPS: 443
<br>
<hr>
<br>

<h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

<h2>Important note about name/org change:</h2>
<p>
Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
</p>
<p>
The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though. 
</p>
<p>
- Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
</p>

<h2>Some important URLs:</h2>

<ul>
  <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

  <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
</ul>

<br>
Or:
<br>

<pre>
  <code>
  docker pull wbitt/network-multitool
  </code>
</pre>


<hr>
```
с backend до frontend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/backend -n app -- timeout 5 curl -s http://frontend.app.svc.cluster.local
command terminated with exit code 143
```
с cache до frontend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/cache -n app -- timeout 5 curl -s http://frontend.app.svc.cluster.local
command terminated with exit code 143
```
с cache до backend
```bash
glubuchik@glubuchik-X15-AT-22:~/обучение/Netology/kubernetes/3.3$ kubectl exec -it deployment/cache -n app -- timeout 5 curl -s http://backend.app.svc.cluster.local
command terminated with exit code 143
```
**Вывод:** после включения сетевых политик трафик разрешен только frontend -> backend -> cache, другие виды подключений запрещены.



### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.