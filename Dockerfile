FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/kubernetes-incubator/service-catalog
COPY . .
RUN make build; \
    mkdir -p /tmp/build; \
    cp /go/src/github.com/kubernetes-incubator/service-catalog/_output/local/bin/linux/$(go env GOARCH)/service-catalog /tmp/build/;

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /tmp/build/service-catalog /usr/bin/
COPY manifests /manifests/
CMD ["/usr/bin/service-catalog"]
