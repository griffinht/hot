FROM authelia/authelia:4.37

# dont use the regular config directory because it is a volume!!! ahhhh!
COPY configuration.yml /configuration.yml

#https://www.authelia.com/configuration/methods/files/
CMD "authelia" "--config=/configuration.yml"
