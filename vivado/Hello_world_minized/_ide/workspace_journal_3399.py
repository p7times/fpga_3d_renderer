# 2026-01-02T16:06:52.764003
import vitis

client = vitis.create_client()
client.set_workspace(path="Hello_world_minized")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "hello_world_minized_platform",hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

platform = client.get_component(name="hello_world_minized_platform")
status = platform.build()

comp = client.create_app_component(name="hello_world_application",platform = "$COMPONENT_LOCATION/../hello_world_minized_platform/export/hello_world_minized_platform/hello_world_minized_platform.xpfm",domain = "standalone_ps7_cortexa9_0")

comp = client.create_app_component(name="hello_world_template",platform = "$COMPONENT_LOCATION/../hello_world_minized_platform/export/hello_world_minized_platform/hello_world_minized_platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

client.delete_component(name="hello_world_application")

status = platform.build()

comp = client.get_component(name="hello_world_template")
comp.build()

vitis.dispose()

