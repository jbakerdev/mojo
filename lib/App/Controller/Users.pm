package App::Controller::Users;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Try::Tiny;
use Data::Dumper;

# GET /users
sub index($c) {
  $c->stash(
    users => $c->schema->resultset('User')
  );
}

# GET /users/1
sub show($c) {
  $c->set_user;
}

# GET /users/new
sub nu($c) {
  $c->stash(
    user => $c->model('User')->new( $c->user_params )
  );

  $c->render('users/new');
}

# GET /users/1/edit
sub edit($c) {
  $c->set_user;
}

# POST /users
sub create($c) {
  my $user;
  try {
    $user = $c->schema->resultset('User')->create( $c->user_params );

    if ($user->id) {
      $c->flash(message => 'User created successfully!');
      $c->redirect_to('user', id => $user->id);
    }
    else {
      $c->flash(errors => 'Error creating user');
      $c->stash(
        user => $c->schema->resultset('User')->new( $c->user_params )
      );
      $c->render('users/new');
    }
  }
  catch {
    $c->flash(error => "Code error: $_");
    $c->redirect_to('new_user');
  };
}

# PATCH/PUT /users/1
sub update($c) {
  $c->set_user;

  my $user;
  try {
    $user = $c->stash('user')->update($c->user_params);

    if ($user->id) {
      $c->flash(message => "User $user->id updated successfully!");
      $c->redirect_to('user', id => $user->id);
    }
    else {
      $c->flash(errors => 'Error updating user');
      $c->stash(
        user => $c->schema->resultset('User')->new($c->user_params)
      );
      $c->render('users/edit');
    }
  }
  catch {
    $c->flash(error => "Code error: $_");
    $c->redirect_to('new_user');
  };
}

# DELETE /users/1
sub delete($c) {
  $c->set_user;

  try {
    $c->stash('user')->delete;

    $c->flash( message => "User deleted successfully!" );
  }
  catch {
    $c->flash( error => "Error deleting user: $_" );
  };

  $c->redirect_to('users');
}

# private

sub set_user($c) {
  my $id = $c->stash('id');
  $c->stash(
    user => $c->schema->resultset('User')->find( $id )
  );
}

sub user_params($c) {
  {
    title   => $c->param('title'),
    content => $c->param('content')
  }
}

1;
