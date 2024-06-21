FROM registry.scontain.com:5050/sconecuratedimages/node:16.13.1-alpine3.15-scone5.8 as release

RUN apk update

RUN cd /

#WORKDIR /usr/app
RUN apk add bash

ENV SCONE_MODE=SIM
ENV SCONE_HEAP=256M
ENV SCONE_LOG=DEBUG
#ENV SCONE_ALLOW_DLOPEN=2

#RUN npm i -g @vercel/ncc
##RUN ncc version
##
#RUN npm install -g pkg

RUN mkdir binary-fs-dir

COPY src/* /etny-nodenithy/
COPY scripts/* /etny-nodenithy/

WORKDIR /etny-nodenithy
RUN pwd
RUN npm install
RUN ls

WORKDIR /

RUN ["chmod", "+x", "etny-nodenithy/binary-fs-build.sh"]
RUN etny-nodenithy/binary-fs-build.sh

FROM registry.scontain.com:5050/sconecuratedimages/crosscompilers as build

COPY --from=release /binary-fs-dir /.

RUN scone gcc ./binary_fs_blob.s ./libbinary_fs_template.a -shared -o /libbinary-fs.so

#
FROM registry.scontain.com:5050/sconecuratedimages/node:16.13.1-alpine3.15-scone5.8

COPY --from=build /libbinary-fs.so /lib/libbinary-fs.so
#
ENV SCONE_EXTENSIONS_PATH="/lib/libbinary-fs.so"
ENV SCONE_LOG=info

#RUN scone cas attest scone-cas.cf 3061b9feb7fa67f3815336a085f629a13f04b0a1667c93b14ff35581dc8271e4 -GCS --only_for_testing-debug --only_for_testing-ignore-signer
RUN ls /usr/local/bin
ENTRYPOINT ["/usr/local/bin/node", "/etny-nodenithy/etny_result.js"]
