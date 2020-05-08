#!/bin/bash

for skill_deps in skills/*/requirements.txt;
    do /usr/bin/pip3 install -r $skill_deps;
done
/opt/mycroft/start-mycroft.sh all
tail -f /var/log/mycroft/*.log
