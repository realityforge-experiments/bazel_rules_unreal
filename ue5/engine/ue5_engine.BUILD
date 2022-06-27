package(default_visibility = ["//visibility:public"])

sh_binary(
  name = "RunUAT.bat",
  srcs = ["@unreal_engine//:Engine/Build/BatchFiles/RunUAT.bat"]
  )

"""
exports_files([
    "Engine/Binaries/DotNET/AutomationTool/AutomationTool.exe",
    "Engine/Binaries/Win64/UnrealEditor.exe", 
    "Engine/Binaries/Win64/UnrealEditor-cmd.exe"]
    )
"""

exports_files(glob(["*/**"]))