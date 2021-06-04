package App::Controller::Home;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub index ($self) {
  $self->render;
}

1;
