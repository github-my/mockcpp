
function InitEnviroment {
	param (
		$compiler_name,
		$compiler_major_version,
		$cmake_param
	)
	# Running Powershell must be Windows
    $global:MY_OS_NAME="Windows"

	$global:MY_CXX_COMPILER_NAME=$compiler_name
	$global:MY_CXX_COMPILER_MAJOR_VERSION=$compiler_major_version
	$global:CMAKE_COMPILER_PARAM=$cmake_param

	if ($compiler_name -eq "MSVC") {
		$global:MAKE_BUILD_TYPE="Debug"
	} elseif ($compiler_name -eq "GNU") {
		$global:MAKE_BUILD_TYPE="."
	}
}

function CompileProject {
	param (
		$compiler_name,
		$project_dir
	)
	if ($compiler_name -eq "MSVC") {
		cd $project_dir
        Invoke-Expression "msbuild ALL_BUILD.vcxproj"
        cd ..\..  # Assuming two levels directory
	} elseif ($compiler_name -eq "GNU") {
		Invoke-Expression "make -C $project_dir"
	}
}

function CompileProjectInstall {
	param (
		$compiler_name,
		$project_dir
	)
	if ($compiler_name -eq "MSVC") {
		cd $project_dir
        Invoke-Expression "msbuild INSTALL.vcxproj"
        cd ..\..  # Assuming two levels directory
	} elseif ($compiler_name -eq "GNU") {
		Invoke-Expression "make -C $project_dir install"
	}
}

function RunTests {
	param (
		$build_dir,
		$tested_project,
		$build_type,
		$testing_tool,
		$st_suffix
	)
	cd $build_dir/$tested_project/ut/$build_type
	if ($build_type -eq ".") {
		$BUILD_TYPE_BACK="."
	} else {
		$BUILD_TYPE_BACK=".."
	}
	$LISTENER_PATH="..\..\$BUILD_TYPE_BACK\$testing_tool\src\listeners\$build_type"
	$RUNNER_PATH="..\..\$BUILD_TYPE_BACK\$testing_tool\src\runner\$build_type"
	$ALL_DLL=(ls *.dll -name)-replace ".dll"
	Invoke-Expression "$RUNNER_PATH\testngpp${st_suffix}-runner.exe  $ALL_DLL -L`"$LISTENER_PATH`" -l`"testngpp${st_suffix}stdoutlistener -c -v`" -m"
	cd ..\..\..\$BUILD_TYPE_BACK
}

function RunTestsFromPrebuiltTools {
    param (
        $build_dir,
		$tested_project,
		$build_type,
        $os_compiler
    )
    cd $build_dir/$tested_project/$build_type
    if ($build_type -eq ".") {
		$BUILD_TYPE_BACK="."
	} else {
		$BUILD_TYPE_BACK=".."
	}
    $LISTENER_PATH="..\..\$BUILD_TYPE_BACK\tests\testngpp\binary\$os_compiler\testngpp\listener"
    $RUNNER_PATH="..\..\$BUILD_TYPE_BACK\tests\testngpp\binary\$os_compiler\testngpp\bin"
    $ALL_DLL=(ls *.dll -name)-replace ".dll"
    Invoke-Expression "$RUNNER_PATH\testngpp-runner.exe  $ALL_DLL -L`"$LISTENER_PATH`" -l`"testngppstdoutlistener -c -v`" -m"
    cd ..\..\$BUILD_TYPE_BACK
}