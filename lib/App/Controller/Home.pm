package App::Controller::Home;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw/j/;

# This action will render a template
sub index ($self) {
  if ( ! $self->session('auth') ) {
    $self->flash(message => "Please log in");
  }

  $self->stash(session => $self->session);
}

sub connect ($self) {
  my %get_token = (
    redirect_uri => $self->url_for('connect')->userinfo(undef)->to_abs,
  );

  $self->log->info('Connecting...');

  return $self->oauth2->get_token_p(github => \%get_token)->then(sub {
    return unless my $provider_res = shift;

    # Token received
    $self->session(token => $provider_res->{code});
    return $self->login('github', $provider_res->{access_token});
  })->catch(sub {
    my $error = shift;
    $self->flash(error => $error);
    $self->render('home/index', error => $error);
  });
};

sub login {
  my ($self, $service_name, $access_token) = @_;

  my $service_urls = {
    github => 'https://api.github.com/user',
  };

  my $service_url = $service_urls->{$service_name};

  my $ua = Mojo::UserAgent->new->request_timeout(5);

  my $service_user_jsonstr = $ua->get($service_url => { Authorization => "token $access_token" })->res->body;
  my $service_user = j( $service_user_jsonstr );

  # Find or create user in DB
  my $user = $self->schema->resultset('User')->find_or_new({
    name => $service_user->{name},
    email => $service_user->{email}
  });

  if( !$user->in_storage ) {
    $user->insert;
  }

  $self->session(
    auth    => 1,
    user_id => $user->id,
    name    => $user->name,
    email   => $user->email
  );

  $self->flash(message => "You have logged in");

  $self->redirect_to('/');
}

sub logout ($self) {
  $self->session(expires => 1);

  $self->flash(message => "You have been logged out");

  $self->redirect_to('/');
}

1;
