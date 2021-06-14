FROM perl
WORKDIR /opt/app
COPY . .
RUN cpanm --installdeps -n .
EXPOSE 3000
CMD ./script/app prefork
