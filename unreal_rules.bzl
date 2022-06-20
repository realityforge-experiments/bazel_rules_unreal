def _build_game_impl(ctx):

    out = ctx.actions.declare_file("out.txt")

    ctx.actions.run(outputs=[out], executable=ctx.executable.build_tool, arguments=[""])

    return DefaultInfo(files=depset([out]), executable=out)


build_game = rule(
    implementation=_build_game_impl,
    attrs={
        "build_tool": attr.label(executable=True, cfg="exec"),
        "unreal_engine": attr.label(),
        "unreal_project": attr.label(),
    },
)
