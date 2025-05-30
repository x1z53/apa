project(
  'apa',
  ['vala', 'c'],
  version : '0.1.8.alpha',
  meson_version: '>= 1.0.0',
  license: 'GPL-3.0-or-later',
  default_options: ['prefix=/usr']
)

MIN_GLIB_VERSION = '2.76'

i18n = import('i18n')

apa_sysconf_dir = get_option('sysconfdir') / meson.project_name()

glib_dep = dependency ('glib-2.0', version: '>= ' + MIN_GLIB_VERSION)
gobject_dep = dependency ('gobject-2.0')
gio_dep = dependency ('gio-2.0')
gee_dep = dependency ('gee-0.8')
libalt_repo_dep = dependency('libalt-repo-1', version: '>= 1.19.16', fallback : ['libalt-repo', 'lib_dep'])
libvazzy_dep = dependency('libvazzy-1', version: '>= 1.4', fallback : ['libvazzy', 'lib_dep'])
libapi_base_dep = dependency('libapi-base-1')
rpm_dep = dependency('rpm')

apa_dependencies = [
  glib_dep,
  gobject_dep,
  gio_dep,
  gee_dep,
  libalt_repo_dep,
  libvazzy_dep,
  libapi_base_dep,
  rpm_dep,
]

add_project_arguments(
  '-include', 'config.h',
  '-Wno-int-conversion',
  language: ['c']
)

add_project_arguments(
  '--target-glib', MIN_GLIB_VERSION,
  '--vapidir', meson.current_source_dir() / 'vapi',
  language: ['vala']
)

version_suffix = ''

find_program ('apt-get', required: true)
find_program ('apt-cache', required: true)
find_program ('rpm', required: true)
find_program ('apt-repo', required: true)
find_program('update-kernel', dirs: ['/sbin'], required: true)

if get_option('is_devel')
  prog = find_program('git', required: true)
  vcs_tag = run_command(prog.full_path(), 'rev-parse', '--short', 'HEAD', check: false).stdout().strip()
  version_suffix = '-dev.' + vcs_tag
endif

conf = configuration_data()
conf.set_quoted('NAME', meson.project_name())
conf.set10('IS_DEVEL', get_option('is_devel'))
conf.set_quoted('VERSION', meson.project_version() + version_suffix)
conf.set_quoted('G_LOG_DOMAIN', meson.project_name())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('KEY_DEFAULTS_DIR', apa_sysconf_dir)
conf.set_quoted('DATADIR', get_option('prefix') / get_option('datadir'))
conf.set_quoted('GNOMELOCALEDIR', get_option('prefix') / get_option('localedir'))

configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

subdir('data')
subdir('po')
subdir('vapi')
subdir('src')
subdir('tests')
