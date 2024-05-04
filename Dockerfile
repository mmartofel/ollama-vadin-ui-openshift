FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.18-3

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

# We make four distinct layers so if there are application changes the library layers can be re-used
# COPY --chown=185 target/quarkus-app/lib/ /deployments/lib/
COPY --chown=185 target/*.jar /deployments/
# COPY --chown=185 target/quarkus-app/app/ /deployments/app/
# COPY --chown=185 target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 185
ENV MODEL="llama3"
ENV AB_JOLOKIA_OFF=""
ENV JAVA_OPTS="-Dserver.address=0.0.0.0"