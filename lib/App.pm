package App;
use Mojo::Base 'Mojolicious', -signatures;

use Lingua::EN::Inflect qw/PL/;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig', {file => 'config/app.yml'});
  my $environment_config = "config/environments/$ENV{MOJO_MODE}.yml";
  if (-f $environment_config) {
    $config = $self->plugin('NotYAMLConfig', {file => $environment_config});
  }

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
      'https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css'
    )
  );

  # Database
  $self->schema->connect();

  # Router
  my $r = $self->routes;

  # Default route
  $r->get('/')->to('home#index');

  # Simple "resource" shortcut
  $r->add_shortcut(resource => sub ($r, $name) {
    # Inflect plural
    my $names = PL($name);

    # Prefix for resource
    my $resource = $r->any("/$names")->to("$names#");

    $resource->get('/')->to('#index')->name($names);
    $resource->get('/new')->to('#nu')->name("new_$name");
    $resource->post->to('#create')->name("create_$name");
    $resource->get('/:id')->to('#show')->name("$name");
    $resource->get('/:id/edit')->to('#edit')->name("edit_$name");
    $resource->put('/:id')->to('#update')->name("update_$name");
    $resource->delete('/:id')->to('#delete')->name("delete_$name");

    return $resource;
  });
}

1;
