package App;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # Load plugins
  $self->plugin('AssetPack' => { pipes => [qw(Sass Css Combine)] });
  $self->plugin('AutoReload');
  $self->plugin('DBIC' => $config->{dbic});
  $self->plugin('OAuth2' => $config->{oauth2});
  
  # Configure assets
  $self->asset->process(
    # virtual name of the asset
    "app.css" => (
      # source files used to create the asset
      "app.scss",
    )
  );

  # Database
  $self->schema->connect();

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
