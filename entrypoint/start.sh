#!/bin/sh
set -e

echo "Adding hostname $ENTRYPOINT_HOSTNAME to the NGINX config"
echo "Adding frontend endpoint $FRONTEND_ENDPOINT to the NGINX config"

# replace env vars in these files and output them to /etc/nginx/conf.d/
for file in /files/*; do

	echo "${file#/files/}"
	# only replace these listed env vars
	envsubst <"$file"  '\
		$DISABLE_SSL_HASH \
		$BACKEND_HOST \
		$FRONTEND_HOST \
		$FRONTEND_ENDPOINT \
		$LISTEN_PORT' | tee "/etc/nginx/conf.d/${file#/files/}"
done

nginx -V
nginx -t && nginx -g 'daemon off;'

