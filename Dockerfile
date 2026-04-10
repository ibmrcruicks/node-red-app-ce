#FROM registry.access.redhat.com/ubi8:8.7-1054.1675788412 as build
FROM registry.redhat.io/rhel8/nodejs-22:latest as build

#RUN  dnf module install --nodocs -y nodejs:22 python31 --setopt=install_weak_deps=0 --disableplugin=subscription-manager \
#    && dnf install --nodocs -y make gcc gcc-c++  --setopt=install_weak_deps=0 --disableplugin=subscription-manager \
#    && dnf clean all --disableplugin=subscription-manager
# RUN npm install --global npm@10
    
RUN mkdir -p /opt/app-root/src
WORKDIR /opt/app-root/src
COPY package.json /opt/app-root/src
RUN npm install --no-audit --no-update-notifier --no-fund --omit=dev
COPY . .

## Release image
FROM registry.redhat.io/rhel8/nodejs-22-minimal:latest

COPY --from=build /opt/app-root/src /opt/app-root/src/

WORKDIR /opt/app-root/src

ENV NODE_ENV=production
ENV PORT 3000
EXPOSE 3000

CMD ["npm", "start"]
