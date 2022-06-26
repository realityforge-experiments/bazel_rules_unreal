
def _build_game_impl(ctx):

    out = ctx.actions.declare_file("out.txt")
    
    ctx.actions.run(
        outputs=[out],
        executable=ctx.executable.build_tool,
        arguments=[
            ctx.files.uat[0].path,
            ctx.files.project_file[0].path,
        ],
        # use_default_shell_env=True,
    )
    
    ctx.actions.run(
        outputs=[out],
        executable=ctx.files.uat[0],
        arguments=[],
        use_default_shell_env=True,
    )

    return DefaultInfo(files=depset([out]), executable=out)

def load_map_impl(ctx):
    output_log_file = ctx.actions.declare_file("output_log_file.txt")

    ctx.actions.run_shell(
        outputs=[output_log_file],
        command=ctx.executable.unreal_engine_executable.path,
        use_default_shell_env = True,
        arguments=[
            "-project=" + ctx.files.project_file[0].path,
            "-ExecCmds=/"Automation RunTests SourceTests/""
            "-run=resavepackages",
            "-log=" + output_log_file.path,
            "-nullrhi",
            "-game"
            "-unattend"]
    )
    
    return DefaultInfo(files=depset([outpuqt_log_file]))


build_game = rule(
    implementation=_build_game_impl,
    executable=True,
    attrs={
        "build_tool": attr.label(executable=True, cfg="exec"),
        "uat": attr.label(allow_files=True, executable=True, cfg="exec"),
        "project_file": attr.label(
            allow_single_file=True,
        ),
    },
)

load_map = rule( 
    implementation=load_map_impl,
    attrs={
        "unreal_engine_executable": attr.label(
            allow_files=True,
            executable=True,
            cfg="exec"
            ),
        "project_file": attr.label(
            allow_single_file=True,
        ),
        "map_file" : attr.label(
            allow_single_file=True,
        ),
    },

)
