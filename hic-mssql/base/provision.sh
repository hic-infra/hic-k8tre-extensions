#!/bin/sh

SQL_SERVER="sql.ad.${DOMAIN}"

kubectl  -n keycloak get group -o yaml | \
    yq -r '.items[] | select(.spec.members) | .spec | (.projects[0])' | \
    sort -u > /tmp/projects.txt
kubectl  -n keycloak get group -o yaml | \
    yq -r '.items[] | select(.spec.members) | .spec | (.members[] + "-" + .projects[0] + "\t" + .projects[0])' | \
    sort -u > /tmp/usernames.txt

while read project <&3 ; do
    echo "CREATE LOGIN [AD\\$project] FROM WINDOWS;"
done 3< /tmp/projects.txt
rm /tmp/projects.txt

while read username project <&3 ; do
    echo "CREATE LOGIN [AD\\$username] FROM WINDOWS;"
done 3< /tmp/usernames.txt

