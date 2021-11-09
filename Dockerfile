FROM perl
WORKDIR /opt/app
COPY cpanfile .
RUN cpanm --installdeps -n .

COPY . .
EXPOSE 3000
CMD ./script/app prefork
