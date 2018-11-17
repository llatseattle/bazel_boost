include_pattern = "boost/%s/"

hdrs_patterns = [
    "boost/%s.h",
    "boost/%s_fwd.h",
    "boost/%s.hpp",
    "boost/%s_fwd.hpp",
    "boost/%s/**/*.hpp",
    "boost/%s/**/*.ipp",
    "boost/%s/**/*.h",
    "libs/%s/src/*.ipp",
]

srcs_patterns = [
    "libs/%s/src/*.cpp",
    "libs/%s/src/*.hpp",
]

# Building boost results in many warnings for unused values. Downstream users
# won't be interested, so just disable the warning.
default_copts = ["-Wno-unused-value"]

def srcs_list(library_name):
  return native.glob([p % (library_name,) for p in srcs_patterns])

def includes_list(library_name):
  return [".", include_pattern % library_name]

def hdr_list(library_name):
  return native.glob([p % (library_name,) for p in hdrs_patterns])

def boost_library(name, defines=None, includes=None, hdrs=None, srcs=None, deps=None, copts=None, exclude_src=[]):
  if defines == None:
    defines = []

  if includes == None:
    includes = []

  if hdrs == None:
    hdrs = []

  if srcs == None:
    srcs = []

  if deps == None:
    deps = []

  if copts == None:
    copts = []

  return native.cc_library(
    name = name,
    visibility = ["//visibility:public"],
    defines = defines,
    includes = includes_list(name) + includes,
    hdrs = hdr_list(name) + hdrs,
    srcs = [s for s in srcs_list(name) if s not in exclude_src] + srcs,
    deps = deps,
    linkstatic = 1,
    copts = default_copts + copts,
    licenses = ["notice"],
  )

def boost_deps():
  native.new_http_archive(
    name = "booster",
    url = "https://dl.bintray.com/boostorg/release/1.65.0/source/boost_1_65_0.tar.gz",
    build_file = "@boost_local//:BUILD.boost",
    strip_prefix = "boost_1_65_0/",
  )
