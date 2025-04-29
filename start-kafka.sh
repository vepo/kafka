#!/bin/sh

PROPERTIES=./config/kraft/server.properties

for k_var in $(env | grep ^KAFKA_); do
    key="${k_var%=*}"
    key=`echo ${key#"KAFKA_"} | tr "[:upper:]" "[:lower:]" | tr '_' '.'`
    value="${k_var#*=}"

    if ! grep -R "^[#]*\s*${key}=.*" $PROPERTIES > /dev/null; then
        echo "APPENDING because '${key}' not found"
        echo "$key=$value" >> $PROPERTIES
    else
        echo "SETTING because '${key}' found already"
        sed -ir "s~^[#]*\s*$key=.*~$key=$value~" $PROPERTIES
    fi
done

if [[ ! -f /tmp/kraft-combined-logs/meta.properties ]]; then
    cluster_id=`[[ -z "$KAFKA_CLUSTER_ID" ]] && kafka-storage.sh random-uuid || echo "$KAFKA_CLUSTER_ID"`
    echo "Using CLUSTER_ID=$cluster_id"
    kafka-storage.sh format -t $cluster_id -c $PROPERTIES
fi

# Run Kafka
kafka-server-start.sh $PROPERTIES
