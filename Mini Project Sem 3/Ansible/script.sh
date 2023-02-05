#!/bin/bash

export META_INST_AZ=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`
export META_INST_PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`

document='index.html'
appname='project'
cd /var/www/html
rm -r ${document}
echo "<!DOCTYPE html>" >> ${document}
echo "<html lang="en">" >> ${document}
echo "<head>" >> ${document}
echo "    <meta charset="UTF-8">" >> ${document}
echo "    <meta name="viewport" content="width=device-width, initial-scale=1.0">" >> ${document}



echo "    <title>${appname}</title>" >> ${document}
echo "</head>" >> ${document}
echo "<body>" >> ${document}
echo "    <div class="wrapper">" >> ${document}
echo "        <div class="instance-card">" >> ${document}
echo "            <div class="instance-card__cnt">" >> ${document}
echo "                <div class="instance-card__name">Instance $META_INST_ID is running!</div>" >> ${document}
echo "                <div class="instance-card-inf">" >> ${document}


echo "                    <div class="instance-card-inf__item">" >> ${document}
echo "                        <div class="instance-card-inf__txt">Public IP</div>" >> ${document}
echo "                        <div class="instance-card-inf__title">" $META_INST_PUBLIC_IP "</div>" >> ${document}
echo "                    </div>" >> ${document}

echo "                    <div class="instance-card-inf__item">" >> ${document}
echo "                        <div class="instance-card-inf__txt">Availability zone</div>" >> ${document}
echo "                        <div class="instance-card-inf__title">" $META_INST_AZ "</div>" >> ${document}
echo "                    </div>" >> ${document}

echo "                </div>" >> ${document}
echo "            </div>" >> ${document}
echo "        </div>" >> ${document}
echo "</body>" >> ${document}
echo "</html>" >> ${document}

systemctl restart apache2