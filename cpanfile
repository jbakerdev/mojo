requires 'Mojolicious', '== 9.19';

requires 'Mojolicious::Plugin::AssetPack', '== 2.13';
requires 'Mojolicious::Plugin::AutoReload', '== 0.010';
requires 'Mojolicious::Plugin::DBIC', '== 0.003';
requires 'Mojolicious::Plugin::OAuth2', '== 1.59';

requires 'DBD::mysql', '== 4.050';
requires 'DBIx::Class', '== 0.082842';
requires 'Lingua::EN::Inflect', '== 1.905';
requires 'Moose', '== 2.2014';
requires 'MooseX::MarkAsMethods', '== 0.15';
requires 'MooseX::NonMoose', '== 0.26';

on 'develop' => sub {
};

on 'test' => sub {
};
