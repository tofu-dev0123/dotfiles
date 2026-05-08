{ ... }:
# Starship Prompt 設定
# 旧 starship/.config/starship.toml の内容を programs.starship.settings に Nix 式として移植
# https://starship.rs/config/
{
  programs.starship = {
    enable = true;

    settings =
    {
      add_newline = false;
      aws = {
        format = "[[ $symbol ](fg:yellow bg:blue)($profile $region) ]($style)";
        style = "fg:surface0 bg:blue";
      };
      c = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version)]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      character = {
        error_symbol = "[❯](red)";
        success_symbol = "[❯](green)";
      };
      cmd_duration = {
        format = "[ $duration ](fg:blue bold bg:surface0)";
        min_time = 0;
        show_milliseconds = false;
      };
      command_timeout = 1200;
      custom.git_user = {
        description = "現在の git リポジトリの user.name を表示する";
        command = "git config user.name";
        when = "git rev-parse --is-inside-work-tree 2>/dev/null";
        format = "[ $symbol $output ]($style)";
        symbol = "";
        style = "fg:surface0 bg:sky";
      };
      conda = {
        format = "[[ $symbol $environment ](fg:yellow bg:blue)($version) ]($style)";
        ignore_base = false;
        style = "fg:surface0 bg:blue";
        symbol = "";
      };
      dart = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version)]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = " ";
      };
      directory = {
        before_repo_root_style = "fg:overlay0 bg:green";
        format = "[ $symbol $path ]($style)([$read_only ]($read_only_style))";
        home_symbol = "󰠦 ";
        read_only = "󰌾 ";
        read_only_style = "fg:red bold bg:green";
        repo_root_format = "[ $before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only ]($read_only_style)";
        repo_root_style = "fg:surface0 bold bg:green";
        style = "fg:surface0 bg:green";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
        truncate_to_repo = false;
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      docker_context = {
        format = "[[ $symbol ](fg:yellow bg:blue)($context) ]($style)";
        style = "fg:surface0 bg:blue";
      };
      fill = {
        symbol = " ";
      };
      format = "[](fg:yellow)$os[](fg:yellow bg:green)$directory[](fg:green bg:sky)\${custom.git_user}$git_branch$git_status[](fg:sky bg:sapphire)$c$dart$gcloud$golang$gradle$java$kotlin$lua$nodejs$php$python$typst$ruby$rust[](fg:sapphire bg:blue)$conda$docker_context$package$aws[](fg:blue bg:surface0)$cmd_duration[](fg:surface0)$line_break$username$character";
      gcloud = {
        disabled = true;
      };
      git_branch = {
        format = "[ $symbol $branch]($style)";
        style = "fg:surface0 bg:sky";
        symbol = "";
      };
      git_status = {
        format = "[($all_status $ahead_behind) ]($style)";
        style = "fg:surface0 bg:sky";
      };
      golang = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      gradle = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = " ";
      };
      java = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = " ";
      };
      kotlin = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = " ";
      };
      lua = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "󰢱";
      };
      nodejs = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      os = {
        disabled = false;
        format = "[$symbol ]($style)";
        style = "fg:surface0 bg:yellow";
        symbols = {
          Alpine = " ";
          Arch = "  ";
          Artix = "󰣇 ";
          CentOS = " ";
          Debian = "  ";
          Fedora = "󰣛 ";
          Macos = "  ";
          RedHatEnterprise = "󱄛";
          Redhat = "󱄛 ";
          Ubuntu = "  ";
          Windows = "  ";
        };
      };
      package = {
        format = "[[ $symbol ](fg:yellow bg:blue)($version) ](fg:surface0 bg:blue)";
        symbol = "";
      };
      palette = "CatppuccinFrappe";
      palettes = {
        CatppuccinFrappe = {
          base = "#303446";
          blue = "#8caaee";
          crust = "#232634";
          flamingo = "#eebebe";
          green = "#a6d189";
          lavender = "#babbf1";
          mantle = "#292c3c";
          maroon = "#ea999c";
          mauve = "#ca9ee6";
          overlay0 = "#737994";
          overlay1 = "#838ba7";
          overlay2 = "#949cbb";
          peach = "#ef9f76";
          pink = "#f4b8e4";
          red = "#e78284";
          rosewater = "#f2d5cf";
          sapphire = "#85c1dc";
          sky = "#99d1db";
          subtext0 = "#a5adce";
          subtext1 = "#b5bfe2";
          surface0 = "#414559";
          surface1 = "#51576d";
          surface2 = "#626880";
          teal = "#81c8be";
          text = "#c6d0f5";
          yellow = "#e5c890";
        };
      };
      php = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      python = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        python_binary = [ "python" "python3" ];
        style = "fg:surface0 bg:sapphire";
        symbol = " ";
      };
      ruby = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      rust = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      time = {
        disabled = true;
        format = "[  $time ]($style)";
        style = "fg:surface0 bg:blue";
        time_format = "%R";
      };
      typst = {
        format = "[[ $symbol ](fg:yellow bg:sapphire)($version) ]($style)";
        style = "fg:surface0 bg:sapphire";
        symbol = "";
      };
      username = {
        aliases = {
          my_name = "おいら";
        };
        disabled = false;
        format = "[  $user]($style) ";
        show_always = true;
        style_root = "red bold";
        style_user = "sapphire bold";
      };
    };
  };
}
