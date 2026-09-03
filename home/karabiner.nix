{ pkgs, lib, ... }:

let
  # Elecom HUGE trackball (wired); ids from `hidutil list`.
  hugeVendorId = 1390;
  hugeProductId = 284;

  hugeButton = button: description: to: {
    inherit description;
    manipulators = [
      {
        type = "basic";
        from.pointing_button = button;
        inherit to;
        conditions = [
          {
            type = "device_if";
            identifiers = [
              {
                vendor_id = hugeVendorId;
                product_id = hugeProductId;
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  # Read-only store symlink: edit here and rebuild; the Karabiner GUI cannot save.
  xdg.configFile."karabiner/karabiner.json" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    text = builtins.toJSON {
      global.show_in_menu_bar = true;
      profiles = [
        {
          name = "Default";
          selected = true;
          virtual_hid_keyboard.keyboard_type_v2 = "ansi";
          # Pointing devices are ignored unless opted in.
          devices = [
            {
              identifiers = {
                vendor_id = hugeVendorId;
                product_id = hugeProductId;
                is_pointing_device = true;
              };
              ignore = false;
            }
          ];
          complex_modifications.rules = [
            {
              description = "Caps Lock: Esc on tap, Ctrl on hold";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "caps_lock";
                    modifiers.optional = [ "any" ];
                  };
                  to = [ { key_code = "left_control"; } ];
                  to_if_alone = [ { key_code = "escape"; } ];
                }
              ];
            }
            # Fn1-Fn3 report as button6-8; back/forward (button4/5) stay native.
            (hugeButton "button6" "HUGE Fn1: Mission Control" [
              { apple_vendor_keyboard_key_code = "mission_control"; }
            ])
            (hugeButton "button7" "HUGE Fn2: Copy" [
              { key_code = "c"; modifiers = [ "left_command" ]; }
            ])
            (hugeButton "button8" "HUGE Fn3: Paste" [
              { key_code = "v"; modifiers = [ "left_command" ]; }
            ])
          ];
        }
      ];
    };
  };
}
