{
  schema_class => "App::Schema",
    connect_info => {
      dsn   => 'dbi:mysql:database=mojo_dev',
      user  => 'root',
    },
    loader_options => {
      dump_directory          => "lib",
      omit_version            => 1,
      omit_timestamp          => 1,
      overwrite_modifications => 1,
      preserve_case           => 1,
      #result_base_class       => "App::Schema::Result",
      use_moose               => 1,
    },
}
