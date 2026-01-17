# 2026-01-02T20:39:03.859712
import vitis

client = vitis.create_client()
client.set_workspace(path="blink")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "blink_platform",hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

platform = client.get_component(name="blink_platform")
status = platform.build()

comp = client.create_app_component(name="blink_component",platform = "$COMPONENT_LOCATION/../blink_platform/export/blink_platform/blink_platform.xpfm",domain = "standalone_ps7_cortexa9_0")

status = platform.build()

client.delete_component(name="blink_component")

comp = client.create_app_component(name="blink_application",platform = "$COMPONENT_LOCATION/../blink_platform/export/blink_platform/blink_platform.xpfm",domain = "standalone_ps7_cortexa9_0")

status = platform.build()

comp = client.get_component(name="blink_application")
comp.build()

vitis.dispose()

