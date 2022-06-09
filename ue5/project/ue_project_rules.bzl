
def _build_impl(ctx):
    out_file = ctx.actions.declare_file("out.zip")

    # engine_root = sys.argv[1]
    # project_file_path = sys.argv[2]
    # profile = sys.argv[3]
    # output_directory = sys.argv[4]
    
    ctx.actions.run()
    print(ctx.attr.absolute_engine_path)

    return DefaultInfo(files = depset([out_file]))

build_project = rule (
    implementation = _build_impl,
    attrs = {
        "absolute_engine_path":  attr.string(),
        "_python_compiler": attr.label(
            executable = True,
            cfg = "exec",
            allow_files = True,
            default = "//ue5/buildscripts:build_game_client",
        ),
    }
)
