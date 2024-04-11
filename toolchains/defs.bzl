DemoToolchainInfo = provider(fields = ["compiler"])

_COMPILER_SCRIPT = """\
#!/usr/bin/env bash
cat >"$1" <<EOF
output:             $1
execution platform: {exec}
target platform:    {target}
compiler version:   {version}
EOF
"""

def _demo_toolchain_impl(ctx):
    compiler = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
	compiler,
	_COMPILER_SCRIPT.format(
	    exec = ctx.attr.exec_platform,
	    target = ctx.attr.target_platform,
	    version = ctx.attr.version,
	),
	is_executable = True,
    )
    demo_toolchain_info = DemoToolchainInfo(
	compiler = compiler,
    )
    return [platform_common.ToolchainInfo(demo_toolchain_info = demo_toolchain_info)]

demo_toolchain = rule(
    _demo_toolchain_impl,
    attrs = {
	"exec_platform": attr.string(),
	"target_platform": attr.string(),
	"version": attr.string(),
    },
)

def _demo_impl(ctx):
    demo_toolchain_info = ctx.toolchains["//toolchains:toolchain_type"].demo_toolchain_info

    output = ctx.actions.declare_file(ctx.label.name + ".out")
    args = ctx.actions.args()
    args.add(output)
    ctx.actions.run(
	outputs = [output],
	executable = demo_toolchain_info.compiler,
	arguments = [args],
	mnemonic = "Demo",
	progress_message = "Building %{label}, writing %{output}",
	toolchain = "//toolchains:toolchain_type",
    )

    return [DefaultInfo(files = depset(direct = [output]))]

demo = rule(
    _demo_impl,
    attrs = {},
    toolchains = ["//toolchains:toolchain_type"],
)

def _demo_transition_impl(settings, attr):
    return {
	"//toolchains:version": attr.version,
    }

_demo_transition = transition(
    implementation = _demo_transition_impl,
    inputs = [],
    outputs = ["//toolchains:version"],
)

def _demo_versioned_impl(ctx):
    return [ctx.attr.actual[0][DefaultInfo]]

demo_versioned = rule(
    _demo_versioned_impl,
    attrs = {
	"actual": attr.label(cfg = _demo_transition, mandatory = True),
	"version": attr.string(mandatory = True),
    },

)
