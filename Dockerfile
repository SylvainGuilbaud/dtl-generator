# ARG IMAGE=intersystemsdc/irishealth-community
# ARG IMAGE=intersystemsdc/iris-community
ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2024.3

FROM $IMAGE

WORKDIR /home/irisowner/dev/

ARG TESTS=0
ARG MODULE="interoperability-sample"
ARG NAMESPACE="USER"

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris merge IRIS merge.cpf && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
