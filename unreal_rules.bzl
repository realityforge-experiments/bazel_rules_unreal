def list_blueprints_in_project_impl(ctx):

    output_file = ctx.actions.declare_file("blueprints.txt")
    file_to_run = ctx.actions.declare_file("list_blueprints.bat")

    engine_plus_project_path = "\"" + ctx.executable.engine_executable.path + "\" " + "%cd%/" + ctx.files.project_file[0].short_path 

    # The command that runs the test
    test_command = " -editortest -Execcmds=\"Automation SetFilter Stress, Automation list"

    #UE Arguments
    arguments = " -unattended -nosplash -nopause -nosplash -nullrhi"

    # Write the command into bat file
    ctx.actions.write(
        output=file_to_run,
        content = engine_plus_project_path + " -abslog=" + "%cd%/" + output_file.path + test_command + arguments + " -testexit=\"Automation Test Queue Empty\"",
        is_executable=True)

    # Execute the pat file and making sure that the the blueprint we passed in gets flagged as an input so that Bazel detects any changes to it
    ctx.actions.run(
        outputs=[output_file],
        inputs =[],
        executable=file_to_run
    )
    
    # return the output file so that it can be used in other build steps
    return DefaultInfo(files=depset([output_file]))

def compile_blueprint_impl(ctx):

    # Get the name of the blueprint that we are processing
    blueprint_name = ctx.files.blueprint[0].basename.replace("." + ctx.files.blueprint[0].extension,"")

    # Declare the output file that will contain the log 
    output_file = ctx.actions.declare_file(blueprint_name + ".txt")

    # Declare the run file which will be executed
    file_to_run = ctx.actions.declare_file("run_compile_blueprint" + blueprint_name + ".bat")

    # Path to unreal and the project file
    engine_plus_project_path = "\"" + ctx.executable.engine_executable.path + "\" " + "%cd%/" + ctx.files.project_file[0].short_path 

    # The command that runs the test
    test_command = " -editortest -Execcmds=\"Automation SetFilter Stress, Automation list, Automation RunTest Project.Blueprints.Compile Blueprints." + blueprint_name + "\""
    
    #UE Arguments
    arguments = " -unattended -nosplash -nopause -nosplash -nullrhi"
    
    # Write the command into bat file
    ctx.actions.write(
        output=file_to_run,
        content = engine_plus_project_path + " -abslog=" + "%cd%/" + output_file.path + test_command + arguments + " -testexit=\"Automation Test Queue Empty\"",
        is_executable=True)

    # Execute the pat file and making sure that the the blueprint we passed in gets flagged as an input so that Bazel detects any changes to it
    ctx.actions.run(
        outputs=[output_file],
        inputs =[ctx.files.blueprint[0]],
        executable=file_to_run,
    )
    
    # return the output file so that it can be used in other build steps
    return DefaultInfo(files=depset([output_file]))


def run_uat_impl(ctx):
    out = ctx.actions.declare_file("out.txt") # file that will be generated
    bat = ctx.actions.declare_file("run.bat") # file that will contain the command
    
    # Assemble the command that will be executed
    ctx.actions.write(
        output=bat,
        content = "New-Item -Path " + out.path + " -ItemType File -Command Exit",
        is_executable=True)

    # Use cmd.exe to run the command we just made (plugged into tools)
    ctx.actions.run(
        outputs=[out],
        executable="powershell.exe",
        tools = [bat],
        mnemonic = "CopyFile",
        progress_message = "Copying files",
        use_default_shell_env = True,
    )

    # return the output file so that it can be used in other build steps
    return DefaultInfo(files=depset([out]))

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
        )
    },

)


list_blueprints_in_project = rule( 
    implementation=list_blueprints_in_project_impl,
    attrs={
        "engine_executable": attr.label(
            allow_single_file=True,
            executable=True,
            cfg="exec"
            ),
        "project_file": attr.label(
            allow_single_file=True,
        )
    }
)

run_uat = rule( 
    implementation=run_uat_impl,
    attrs={
        "engine_executable": attr.label(
            allow_single_file=True,
            executable=True,
            cfg="exec"
            ),
        "project_file": attr.label(
            allow_single_file=True,
        )
    }
)