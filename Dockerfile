FROM unityci/editor:ubuntu-6000.0.21f1-base-3.1.0

LABEL "com.github.actions.name"="Unity - Return License"
LABEL "com.github.actions.description"="Return a Unity Pro license and free up a spot towards the maximum number of active licenses."
LABEL "com.github.actions.icon"="box"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="http://github.com/webbertakken/unity-actions"
LABEL "homepage"="http://github.com/webbertakken/unity-actions"
LABEL "maintainer"="Webber Takken <webber@takken.io>"

ADD entrypoint.sh /entrypoint.sh
COPY services-config.json.template /services-config.json.template
RUN chmod +x /entrypoint.sh
RUN chmod 644 /services-config.json.template
ENTRYPOINT ["/entrypoint.sh"]
