load("@rules_python//python:defs.bzl", "py_binary", "py_library")

py_binary(
  name = "build_game_client",
  main = "//ue5/buildscripts:build_game.py",
  srcs = ["//ue5/buildscripts:build_game.py"],
)

exports_files(["build_game.py", "cook_content.py"])