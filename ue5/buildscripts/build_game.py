import sys
import pathlib
import copy
import subprocess
import os

run_uat_tool = sys.argv[1]
run_uat_tool = pathlib.Path(run_uat_tool)

print(os.getcwd())
print(run_uat_tool)
print(f"Exists: {run_uat_tool.exists()}")

project_file_path = sys.argv[2]
project = pathlib.Path(project_file_path)

print(project.absolute())
print(f"Exists: {project.exists()}")

# profile = sys.argv[3]

# output_directory = sys.argv[4]
output_directory = "out/"

run_uat_tool = pathlib.Path(run_uat_tool)
output_directory = pathlib.Path(output_directory)

build_flags = {
    "existence_windows_debug_client": [
        "-clientconfig=Debug",
        "-cook",
        "-iterate",
        "-nop4",
        "-build",
        "-stage",
        "-archive",
        "-pak",
        "-nodebuginfo",
        "-noPCH",
        "-prereqs",
        "-CrashReporter",
    ],
    "existence_windows_shipping_client": [
        "-clientconfig=Development",
        "-cook",
        "-iterate",
        "-nop4",
        "-nocompile",
        "-nodebuginfo",
        "-noPCH",
    ],
    "kamo_linux_server": [
        "-serverconfig=Development",
        "-targetplatform=Linux",
        "-cook",
        "-server",
        "-build",
        "-stage",
        "-archive",
        "-NoClient",
        "-package",
        "-nodebuginfo",
        "-targetplatform=Linux",
        "-prereqs",
    ],
}


def build_game(run_uat_tool, project, profile, output_directory):
    # run_uat = f"{engine}/Engine/Build/BatchFiles/RunUAT.bat"

    cmd = [
        run_uat_tool,
        "BuildCookRun",
        f"-project={project.absolute()}",
        f"-archivedirectory={output_directory}",
    ]

    flags = copy.copy(build_flags[profile])
    cmd.extend(flags)

    subprocess.run(cmd)


build_game(run_uat_tool, project, "existence_windows_shipping_client", output_directory)
