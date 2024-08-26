#!/bin/bash
# This batch job runs the solargeometry and ogivc app kubectl installers

if [ -r ./solargeometry/kubectl-deploy-solargeometry.sh ]; then
	. ./solargeometry/kubectl-deploy-solargeometry.sh
else
	echo 'Solargeometry app installer ./solargeometry/kubectl-deploy-solargeometry.sh not found.'
	exit 1
fi
if [ -r ./ogivc/kubectl-deploy-ogivc.sh ]; then
	. ./ogivc/kubectl-deploy-ogivc.sh
else
	echo 'OGIVC app installer ./ogivc/kubectl-deploy-ogivc.sh not found.'
	exit 1
fi
