BACKEND=${REGISTRY:-registry:5000}
echo "Using backend $BACKEND"

ENTRY="upstream docker-registry { server $REGISTRY; }"


echo $ENTRY  > /etc/nginx/conf.d/docker-registry_upstream.conf

nginx

