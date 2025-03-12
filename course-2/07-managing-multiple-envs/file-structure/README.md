### How to run

Global is used for sharing resource among multiple env, so we need to provision it first. In both production and staging, we turn off create-dns-zone, as we will provision it through global as well.

```bash
cd ./global
terrafrom apply

cd ./production
terrafrom apply

cd ./staging
terrafrom apply
```