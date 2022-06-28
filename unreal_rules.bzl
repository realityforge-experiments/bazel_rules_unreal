
def compile_blueprint_impl(ctx):
    output_log_file = ctx.actions.declare_file("output_log_file.txt")
    run_file = ctx.actions.declare_file("run_me.bat")
    blueprint_name = ctx.files.blueprint[0].basename.replace("." + ctx.files.blueprint[0].extension,"")

    engine_plus_project_path = "\"" + ctx.executable.engine_executable.path + "\" " + "%cd%/" + ctx.files.project_file[0].short_path 
    ctx.actions.write(
        output=run_file,
        content = engine_plus_project_path + " -abslog=" + "%cd%/" + output_log_file.path + " -editortest -Execcmds=\"Automation SetFilter Stress, Automation list, Automation RunTest Project.Blueprints.Compile Blueprints." + blueprint_name +"\"" + " -unattended -nopause -testexit=\"Automation Test Queue Empty\"",
        is_executable=True)

    ctx.actions.run(
        outputs=[output_log_file],
        executable=run_file,
    )
    
    return DefaultInfo(files=depset([output_log_file]))

compile_blueprint = rule( 
    implementation=compile_blueprint_impl,
    attrs={
        "engine_executable": attr.label(
            allow_single_file=True,
            executable=True,
            cfg="exec"
            ),
        "project_file": attr.label(
            allow_single_file=True,
        ),
        "blueprint": attr.label(
            allow_single_file=True,
            default = "BP_GenosPlayerController"
        )
    },

)
